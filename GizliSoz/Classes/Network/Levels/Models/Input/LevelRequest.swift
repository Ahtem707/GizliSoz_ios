//
//  LevelRequest.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 12.05.2023.
//

import Foundation

struct LevelRequest: Codable {
    
    enum CodingKeys: String, CodingKey {
        case levelNumber
        case translateLang
        case voiceoverActor
        case characterType
    }
    
    let levelNumber: Int
    let translateLang: String
    let voiceoverActor: String
    let characterType: CharacterType
}
