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
    
    static func appStart() {
        AppStorage.share = AppStorage()
        
        // Подгружаем уровни из хранилища
        AppStorage.share.levels = AppStorage.levels
        
//        AppStorage.share.runStack.add { AppStorage.share.checkConnect() }
        AppStorage.share.runStack.add { AppStorage.share.fetchAppInit() }
        AppStorage.share.runStack.add { AppStorage.share.fetchLevels() }
    }
    
    static func saveData() {
        // При закрытии приложения сохраняем все данные в кэш
        AppStorage.levels = AppStorage.share.levels
    }
    
    var appInitLoaded: Bool = false
    var isServerAvailable: Bool = true
    var voiceoverHost: URL?
    var translationLangs: [Parameter] = []
    var voiceoverActors: [Parameter] = []
    var levelsCount: Int = 0
    
    var levels: [Level] = []
    
    var currentLevel: Level? {
        return levels.first(where: { $0.levelNumber == AppStorage.currentLevelIndex })
    }
    
    // MARK: - Fetch functions
    
    func checkConnect() {
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
    func fetchAppInit() {
        // Блокирование запроса, если он уже был загружен ранее
        guard !appInitLoaded else { return }
        
        API.Levels.appInit.request(AppInitResponse.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.voiceoverHost = data.voiceoverHost
                self?.translationLangs = data.translationLangs
                self?.voiceoverActors = data.voiceoverActors
                self?.levelsCount = data.levelsCount
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
    func fetchLevels() {
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
        
        // Проверяем на минимальный индекс кэша и не отправляем запрос, если он в пределах допустимого
        let minCacheIndex = AppStorage.currentLevelIndex + AppStorage.levelsCacheCount / 2
        if levelsInCache.contains(minCacheIndex) { return }
        
        // Предварительно определяем уровни которые необходимы
        let startIndex = AppStorage.currentLevelIndex
        var endIndex = AppStorage.currentLevelIndex + AppStorage.levelsCacheCount
        
        // Ограничиваем конечный индекс запрашиваемых уровней, границей существующих уровней
        if endIndex > levelsCount { endIndex = levelsCount }
        
        // Создаем диапазон запрашиваемых уровней и исключаем из них, те что уже существуют в кэше
        var loadLevels = [Int](startIndex..<endIndex)
        loadLevels.removeAll { levelsInCache.contains($0) }
        
        // Если список запрашиваемых уровней пустой, то не отправляем запрос
        guard loadLevels.count > 0 else { return }
        
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
                let index = AppStorage.currentLevelIndex
                if let data = Data.json(fileName: "Level \(index)", with: .json).asCodable(Level.self) {
                    AppStorage.share.levels.append(data)
                } else {
                    AppLogger.log(.storage, error.localizedDescription)
                }
            }
            self?.runStack.next()
        }
    }
}
