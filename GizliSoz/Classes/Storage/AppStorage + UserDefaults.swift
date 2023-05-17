//
//  AppStorage + UserDefaults.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 15.05.2023.
//

import Foundation

extension AppStorage {
    // User value
    @UserDefault("userLoginCount", 0)
    static var userLoginCount: Int
    
    @UserDefault("levelsCacheCount", 30)
    static var  levelsCacheCount: Int
    
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
    static var _voiceoverActor: String {
        didSet { AppStorage.share.fetchLevel() }
    }
    
    @UserDefault("translationLang", "default")
    private static var _translationLang: String {
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
    
    @discardableResult
    static func setLevel(_ value: Int) -> Bool {
        guard value <= levelsCount else {
            assertionFailure("Неправильная установка уровня")
            return false
        }
        
        guard value <= lastOpenedLevelIndex else { return false }
        
        currentLevelIndex = value
        AppStorage.share.fetchLevel()
        return true
    }
    
    static var translationLang: Parameter {
        get {
            if let value = translationLangs.first(where: { $0.code == _translationLang }) {
                return value
            } else if let value = translationLangs.first {
                return value
            } else {
                return Parameter.default
            }
        }
        set {
            _translationLang = newValue.code
        }
    }
    
    static var voiceoverActor: Parameter {
        get {
            if let value = voiceoverActors.first(where: { $0.code == _voiceoverActor }) {
                return value
            } else if let value = voiceoverActors.first {
                return value
            } else {
                return Parameter.default
            }
        }
        set {
            _voiceoverActor = newValue.code
        }
    }
}
