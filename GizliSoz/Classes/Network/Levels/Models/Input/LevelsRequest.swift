//
//  LevelsRequest.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 18.05.2023.
//

import Foundation

struct LevelsRequest: Codable {
    
    enum CodingKeys: String, CodingKey {
        case levelsNumber
        case translateLang
        case voiceoverActor
        case characterType
    }
    
    let levelsNumber: [Int]
    let translateLang: String
    let voiceoverActor: String
    let characterType: CharacterType
}
