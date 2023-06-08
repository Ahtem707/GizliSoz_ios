//
//  AppText.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 02.04.2023.
//

import Foundation

enum AppText {
    enum System {
        static let back = "Artqa"
    }
    
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
        static let infoMessage = "Kenar tarifler"
        static let hintLang = "Terciman tili"
        static let voiceoverActor = "Ses"
        static let levelsCache = "Cache"
        static let alphabet = "Elifbe"
    }
    
    enum LevelsScreen {
        static let levels = MainScreen.levels
    }
    
    enum LevelScreen {
        static let hint = "Ihtar: tesaduf santıra açila"
        static let hammer = "Çöküç ihtari: istegen santırani açmaqa olasiz"
        static let bonusWords = "Sözler: açqan sözlerni köstere"
        static let sound = "Söz sesi avuştırıcı"
    }
}

extension AppText {
    static let ru: [String : String] = [
        "Artqa": "Назад",
        "Seviyeler": "Уровни",
        "Sazlamalar": "Настройки",
        "Başlamaq": "Начать",
        "Devam etem": "Продолжаю",
        "Sözler": "Слова",
        "Qoşma sözler": "Бонусные слова",
        "Kenar tarifler": "Описание поля",
        "Terciman tili": "Язык перевода",
        "Ses": "Голос озвучки",
        "Cache": "Кэш",
        "Elifbe":"Алфавит",
        "Ihtar: tesaduf santıra açila": "Подсказка: открывается любая ячейка",
        "Çöküç ihtari: istegen santırani açmaqa olasiz": "Подсказка молотком: открывается ячейка по вашему выбору",
        "Sözler: açqan sözlerni köstere": "Слова: отображаются открытые слова",
        "Söz sesi avuştırıcı": "Переключатель озвучки слова"
    ]
    
    static let en: [String : String] = [
        "Artqa": "Back",
        "Seviyeler": "Levels",
        "Sazlamalar": "Settings",
        "Başlamaq": "Start",
        "Devam etem": "I continue",
        "Sözler": "Words",
        "Qoşma sözler": "Bonus words",
        "Kenar tarifler": "Description of the field",
        "Terciman tili": "Translation language",
        "Ses": "Voice acting",
        "Cache": "Cache",
        "Elifbe":"Alphabet",
        "Ihtar: tesaduf santıra açila": "Hint: any cell opens",
        "Çöküç ihtari: istegen santırani açmaqa olasiz": "Hammer tip: a cell of your choice opens",
        "Sözler: açqan sözlerni köstere": "Words: Open words are displayed",
        "Söz sesi avuştırıcı": "Switch for voice-over of a word"
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
