//
//  Storage.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

final class AppStorage {
    
    private static var share: AppStorage!
    
    static func appStart() {
        AppStorage.share = AppStorage()
        AppStorage.share.fetchAppInit()
        AppStorage.share.fetchLevel()
    }
    
    static var translationLangs: [Parameter] = []
    static var voiceoverActors: [Parameter] = []
    static var levelsCount: Int = 0
    
    static var levels: [LevelResponse] = []
    
    static var currentLevel: LevelResponse? {
        return levels.first(where: { $0.levelNumber == currentLevelIndex })
    }
    
    // User value
    @UserDefault("userLoginCount", 0)
    static var userLoginCount: Int
    
    @UserDefault("currentLevelIndex", 1)
    private(set) static var currentLevelIndex: Int
    
    @UserDefault("lastOpenedLevelIndex", 1)
    private(set) static var lastOpenedLevelIndex: Int
    
    @UserDefault("hintCount", 10)
    static var hintCount: Int
    
    @UserDefault("hammerCount", 10)
    static var hammerCount: Int
    
    @UserDefault("bonusWords", [])
    static var bonusWords: [String]
    
    @UserDefault("IsActiveVoiceover", true)
    static var isActiveVoiceover: Bool
    
    @UserDefault("voiceoverActor", "default")
    static var voiceoverActor: String {
        didSet { AppStorage.share.fetchLevel() }
    }
    
    @UserDefault("translationLang", "default")
    static var translationLang: String {
        didSet { AppStorage.share.fetchLevel() }
    }
    
    @UserDefault("characterType", CharacterType.latin)
    static var characterType: CharacterType {
        didSet { AppStorage.share.fetchLevel() }
    }
    
    @UserDefault("infoMessage", true)
    static var infoMessage: Bool
    
    static func levelUp() -> Bool {
        if currentLevelIndex < levelsCount {
            currentLevelIndex += 1
            if currentLevelIndex > lastOpenedLevelIndex {
                lastOpenedLevelIndex = currentLevelIndex
            }
            AppStorage.share.fetchLevel()
            return true
        } else {
            return false
        }
    }
    
    static func setLevel(_ value: Int) -> Bool {
        guard currentLevelIndex <= levelsCount else {
            assertionFailure("Неправильная установка уровня")
            return false
        }
        
        guard value <= lastOpenedLevelIndex else { return false }
        
        currentLevelIndex = value
        AppStorage.share.fetchLevel()
        return true
    }
    
    // MARK: - Fetch functions
    
    /// Получаем базовые  данные для приложения
    private func fetchAppInit() {
        API.Levels.appInit.request(AppInitResponse.self) { result in
            switch result {
            case .success(let data):
                Self.translationLangs = data.translationLangs
                Self.voiceoverActors = data.voiceoverActors
                Self.levelsCount = data.levelsCount
            case .failure(let error):
                AppLogger.log(.storage, error.localizedDescription)
            }
        }
    }
    
    /// Загрузка данных уровня
    private func fetchLevel() {
        API.Levels.getLevel(
            .init(
                levelNumber: AppStorage.currentLevelIndex,
                translateLang: AppStorage.translationLang,
                voiceoverActor: AppStorage.voiceoverActor,
                characterType: AppStorage.characterType
            )
        ).request(LevelResponse.self) { result in
            switch result {
            case .success(let data):
                Self.levels.append(data)
            case .failure(let error):
                AppLogger.log(.storage, error.localizedDescription)
            }
        }
    }
    
    /// Загрузка данных уровней
//    private func fetchLevels() {
//        API.Levels.getLevels.request(LevelsResponse.self) { result in
//            switch result {
//            case .success(let data):
//                Self.levels = data.content ?? []
//            case .failure(let error):
//                AppLogger.log(.storage, error.localizedDescription)
//            }
//        }
//    }
}
