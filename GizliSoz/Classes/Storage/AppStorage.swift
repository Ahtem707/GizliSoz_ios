//
//  Storage.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

final class AppStorage {
    
    static var share: AppStorage!
    
    /// Для последовательного запуска запросов
    private let runStack = RunStack()
    
    var appInitLoaded: Bool = false
    var isServerAvailable: Bool = true
    var voiceoverHost: URL?
    var translationLangs: [Parameter] = []
    var voiceoverActors: [Parameter] = []
    var levelsCount: Int = 0
    
    var levels: [Level] = []
    
    var currentLevel: Level? {
        // Получаем кэшированные данные
        if let cacheLevel = levels.first(where: { $0.levelNumber == AppStorage.currentLevelIndex }) {
            return cacheLevel
        }
        
        // Если уровня в кэше нет, используем хардкодные уровни
        let index = AppStorage.currentLevelIndex
        if let storageLevel = Data.json(fileName: "Level \(index)", with: .json).asCodable(Level.self) {
            return storageLevel
        }
        
        return nil
    }
    
    // MARK: - Lifecycle functions
    func appStart() {
        // Подгружаем уровни из хранилища
        levels = AppStorage.levels
        
        fetchAppInit()
        self.fetchLevels()
    }
    
    func saveData() {
        // При закрытии приложения сохраняем все данные в кэш
        AppStorage.levels = levels
    }
    
    // MARK: - Fetch functions
    
    // Проверка подключения
    func checkConnect() {
        runStack.add { self._checkConnect() }
    }
    
    func fetchAppInit() {
        runStack.add { self._fetchAppInit() }
    }
    
    /// Загрузка данных уровня
    func fetchLevels() {
        runStack.add { self._fetchLevels() }
    }
    
    // Проверка подключения
    private func _checkConnect() {
        API.Levels.checkConnect.request(ApiResponse.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.isServerAvailable = data.result == 0
            case .failure(let error):
                self?.isServerAvailable = false
                AppLogger.log(.storage, error.localizedDescription)
            }
            self?.runStack.next()
        }
    }
    
    /// Получаем базовые  данные для приложения
    private func _fetchAppInit() {
        // Блокирование запроса, если он уже был загружен ранее
        guard !appInitLoaded else {
            runStack.next()
            return
        }
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "None"
        
        API.Levels.appInit(
            .init(appVersion: appVersion)
        ).request(AppInitResponse.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.voiceoverHost = data.voiceoverHost
                self?.translationLangs = data.translationLangs
                self?.voiceoverActors = data.voiceoverActors
                self?.levelsCount = data.levelsCount
                self?.appInitLoaded = true
            case .failure(let error):
                if let data = Data.json(fileName: "AppInit", with: .json).asCodable(AppInitResponse.self) {
                    self?.voiceoverHost = data.voiceoverHost
                    self?.translationLangs = data.translationLangs
                    self?.voiceoverActors = data.voiceoverActors
                    self?.levelsCount = data.levelsCount
                } else {
                    AppLogger.log(.storage, error.localizedDescription)
                }
            }
            self?.runStack.next()
        }
    }
    
    /// Загрузка данных уровня
    private func _fetchLevels() {
        // Понижаем уровень до минимально допустимого, если количество загруженных уровней меньше
        if AppStorage.currentLevelIndex > levelsCount {
            AppStorage.setLevel(levelsCount)
        }
        
        // Удаляем пройденные уровни, и те что не соответсвуют настройкам
        AppStorage.share.levels.removeAll {
            $0.levelNumber < AppStorage.currentLevelIndex ||
            $0.levelNumber > AppStorage.currentLevelIndex + AppStorage.levelsCacheCount ||
            $0.translateLang != AppStorage.translationLang.code ||
            $0.voiceoverActor != AppStorage.voiceoverActor.code ||
            $0.characterType != AppStorage.characterType
        }
        
        // Уровни которые находятся в кэше
        let levelsInCache = AppStorage.share.levels.map { $0.levelNumber }
        
        // Минимальный индекс кэша
        let minCacheIndex = AppStorage.currentLevelIndex + AppStorage.levelsCacheCount / 2
        
        // Предварительно определяем обязательные и необязательные уровни
        var mandatoryLevels = Array(AppStorage.currentLevelIndex...minCacheIndex)
        var optionalLevels = Array((minCacheIndex+1)..<AppStorage.currentLevelIndex + AppStorage.levelsCacheCount)
        
        // Исключаем уровни которые уже существуют в кэше и те что за превышают максимальное количество уровней
        mandatoryLevels.removeAll { levelsInCache.contains($0) || $0 > levelsCount }
        optionalLevels.removeAll { levelsInCache.contains($0) || $0 > levelsCount }
        
        // Проверяем на обязательные уровни
        if mandatoryLevels.isEmpty {
            runStack.next()
            return
        }
        
        // Создаем общий массив запрашиваемых уровней
        let loadLevels = mandatoryLevels + optionalLevels
        
        API.Levels.getLevels(
            .init(
                levelsNumber: loadLevels,
                translateLang: AppStorage.translationLang.code,
                voiceoverActor: AppStorage.voiceoverActor.code,
                characterType: AppStorage.characterType
            )
        ).request(LevelsResponse.self) { [weak self] result in
            switch result {
            case .success(let data):
                if let levels = data.levels {
                    AppStorage.share.levels.append(contentsOf: levels)
                } else {
                    AlertsFactory.makeServerError()
                }
            case .failure(let error):
                AppLogger.log(.storage, error.localizedDescription)
            }
            self?.runStack.next()
        }
    }
}
