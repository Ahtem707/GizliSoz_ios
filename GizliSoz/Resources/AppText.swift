//
//  AppText.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 02.04.2023.
//

import Foundation

enum AppText {
    enum MainScreen {
        static let levels = "Seviyeler"
        static let settings = "Sazlamalar"
        static let start = "Başlamaq"
        static let nextButton = "Devam etem"
    }
    
    enum WordsListScreen {
        static let words = "Sözler"
        static let bonusWords = "Qoşma sözler"
    }
    
    enum SettingsScreen {
        static let settings = MainScreen.settings
        static let hint = "Ihtar"
        static let hintLang = "Terciman tili"
        static let voiceoverActor = "Ses"
        static let levelsCache = "Seviyeler cachi"
        static let alphabet = "Elifbe"
    }
    
    enum LevelsScreen {
        static let levels = MainScreen.levels
    }
}

extension AppText {
    static let ru: [String : String] = [
        "Seviyeler": "Уровни",
        "Sazlamalar": "Настройки",
        "Başlamaq": "Начать",
        "Devam etem": "Продолжаю",
        "Sözler": "Слова",
        "Qoşma sözler": "Бонусные слова",
        "Ihtar": "Подсказка",
        "Terciman tili": "Язык перевода",
        "Ses": "Голос озвучки",
        "Seviyeler cachi": "Уровни кэширования",
        "Elifbe":"Алфавит",
    ]
    
    static let en: [String : String] = [
        "Seviyeler": "Levels",
        "Sazlamalar": "Settings",
        "Başlamaq": "Start",
        "Devam etem": "I continue",
        "Sözler": "Words",
        "Qoşma sözler": "Bonus words",
        "Ihtar": "Hint",
        "Terciman tili": "Translation language",
        "Ses": "Voice acting",
        "Seviyeler cachi": "Caching Levels",
        "Elifbe":"Alphabet",
    ]
}

extension String {
    var translate: String? {
        switch AppStorage.translationLang.code {
        case "ru": return AppText.ru[self]
        case "en": return AppText.en[self]
        default: return AppText.en[self]
        }
    }
}
