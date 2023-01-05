//
//  LevelSoundRequest.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 03.01.2023.
//

import Foundation

struct LevelSoundRequest: Codable {
    
    enum CodingKeys: String, CodingKey {
        case wordId
        case voiceActor
    }
    
    let wordId: Int
    let voiceActor: String
}
