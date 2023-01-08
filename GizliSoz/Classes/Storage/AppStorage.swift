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
        AppStorage.share.fetchLevels()
    }
    
    @UserDefault("userLoginCount", 0)
    static var userLoginCount: Int
    
    static var levels: [LevelResponse.Content] = []
    
    static var currentLevel: LevelResponse.Content? {
        guard currentLevelIndex > 0 && levels.count >= currentLevelIndex
        else {
            AppLogger.critical(.logic, "Неправильно выставленный уровень")
            return nil
        }
        
        return levels[currentLevelIndex - 1]
    }
    
    // User value
    @UserDefault("currentLevelIndex", 1)
    private(set) static var currentLevelIndex: Int
    
    @UserDefault("lastOpenedLevelIndex", 1)
    private(set) static var lastOpenedLevelIndex: Int
    
    @UserDefault("hintCount", 5)
    static var hintCount: Int
    
    @UserDefault("hammerCount", 5)
    static var hammerCount: Int
    
    @UserDefault("voiceActorIsActive", true)
    static var voiceActorIsActive: Bool
    
    @UserDefault("voiceActor", "default")
    static var voiceActor: String
    
    @UserDefault("infoMessage", true)
    static var infoMessage: Bool
    
    @UserDefault("infoMessage", "default")
    static var infoMessageLanguage: String
    
    static func levelUp() -> Bool {
        if currentLevelIndex < levels.count {
            currentLevelIndex += 1
            if currentLevelIndex > lastOpenedLevelIndex {
                lastOpenedLevelIndex = currentLevelIndex
            }
            return true
        } else {
            return false
        }
    }
    
    static func setLevel(_ value: Int) -> Bool {
        guard currentLevelIndex <= levels.count else {
            assertionFailure("Неправильная установка уровня")
            return false
        }
        
        guard value <= lastOpenedLevelIndex else { return false }
        
        currentLevelIndex = value
        return true
    }
    
    // MARK: - Fetch functions
    
    /// Загрузка данных уровней
    private func fetchLevels() {
        API.Levels.getLevels.request(LevelResponse.self) { result in
            switch result {
            case .success(let data):
                Self.levels = data.content ?? []
            case .failure(let error):
                AppLogger.log(.storage, error.localizedDescription)
            }
        }
    }
}
