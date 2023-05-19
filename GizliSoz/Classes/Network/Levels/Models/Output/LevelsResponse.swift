//
//  LevelsResponse.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 18.05.2023.
//

import Foundation

struct LevelsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case levels
    }
    
    let levels: [Level]?
}

struct Level: Codable {
    enum CodingKeys: String, CodingKey {
        case levelNumber
        case name
        case nameTranslate
        case size
        case chars
        case words
        case bonusWords
        case translateLang
        case voiceoverActor
        case characterType
    }
    
    let levelNumber: Int
    let name: String
    let nameTranslate: String
    let size: Int
    let chars: [String]
    let words: [Word]
    let bonusWords: [BonusWord]
    let translateLang: String
    let voiceoverActor: String
    let characterType: CharacterType
}

struct Word: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case x
        case y
        case chars
        case translate
        case voiceoverFile
    }
    
    let id: Int
    let x: [Int]
    let y: [Int]
    let chars: [String]
    let translate: String
    let voiceoverFile: String?
    
    var word: String {
        return chars.joined()
    }
}

struct BonusWord: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case word
        case translate
        case voiceoverFile
    }
    
    let id: Int
    let word: String
    let translate: String
    let voiceoverFile: String?
}
