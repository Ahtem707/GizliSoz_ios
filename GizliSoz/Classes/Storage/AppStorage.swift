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
        
//        AppStorage.share.runStack.add { AppStorage.share.checkConnect() }
        AppStorage.share.runStack.add { AppStorage.share.fetchAppInit() }
        AppStorage.share.runStack.add { AppStorage.share.fetchLevel() }
    }
    
    static var appInitLoaded: Bool = false
    static var isServerAvailable: Bool = true
    static var voiceoverHost: URL?
    static var translationLangs: [Parameter] = []
    static var voiceoverActors: [Parameter] = []
    static var levelsCount: Int = 0
    
    static var levels: [LevelResponse] = []
    
    static var currentLevel: LevelResponse? {
        return levels.first(where: { $0.levelNumber == currentLevelIndex })
    }
    
    // MARK: - Fetch functions
    
    func checkConnect() {
        API.Levels.checkConnect.request(ApiResponse.self) { result in
            switch result {
            case .success(let data):
                Self.isServerAvailable = data.result == 0
            case .failure(let error):
                Self.isServerAvailable = false
                AppLogger.log(.storage, error.localizedDescription)
            }
            self.runStack.next()
        }
    }
    
    /// Получаем базовые  данные для приложения
    func fetchAppInit() {
        // Блокирование запроса, если он уже был загружен ранее
        guard !AppStorage.appInitLoaded else { return }
        
        API.Levels.appInit.request(AppInitResponse.self) { result in
            switch result {
            case .success(let data):
                Self.voiceoverHost = data.voiceoverHost
                Self.translationLangs = data.translationLangs
                Self.voiceoverActors = data.voiceoverActors
                Self.levelsCount = data.levelsCount
            case .failure(let error):
                if let data = Data.json(fileName: "AppInit", with: .json).asCodable(AppInitResponse.self) {
                    Self.voiceoverHost = data.voiceoverHost
                    Self.translationLangs = data.translationLangs
                    Self.voiceoverActors = data.voiceoverActors
                    Self.levelsCount = data.levelsCount
                } else {
                    AppLogger.log(.storage, error.localizedDescription)
                }
            }
            self.runStack.next()
        }
    }
    
    /// Загрузка данных уровня
    func fetchLevel() {
        // Понижаем уровень до минимально допустимого, если количество загруженных уровней меньше
        if AppStorage.currentLevelIndex > AppStorage.levelsCount {
            AppStorage.setLevel(AppStorage.levelsCount)
        }
        
        // Удаляем лишние старые уровни превышающие кэш
        let extraLevels = AppStorage.levels.count - AppStorage.levelsCacheCount
        if extraLevels > 0 {
            AppStorage.levels.removeFirst(extraLevels)
        }
        
        // Не подгружаем новый уровень, если он есть в списке
        guard AppStorage.levels.first(where: { $0.levelNumber == AppStorage.currentLevelIndex }) == nil
        else { return }
        
        API.Levels.getLevel(
            .init(
                levelNumber: AppStorage.currentLevelIndex,
                translateLang: AppStorage.translationLang.code,
                voiceoverActor: AppStorage.voiceoverActor.code,
                characterType: AppStorage.characterType
            )
        ).request(LevelResponse.self) { result in
            switch result {
            case .success(let data):
                Self.levels.append(data)
            case .failure(let error):
                let index = AppStorage.currentLevelIndex
                if let data = Data.json(fileName: "Level \(index)", with: .json).asCodable(LevelResponse.self) {
                    Self.levels.append(data)
                } else {
                    AppLogger.log(.storage, error.localizedDescription)
                }
            }
            self.runStack.next()
        }
    }
}
