//
//  LevelSoundResponse.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 03.01.2023.
//

import Foundation

struct LevelSoundResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case result
        case description
        case content
    }
    
    let result: Int
    let description: String?
    let content: Content?
}

extension LevelSoundResponse {
    struct Content: Codable {
        enum CodingKeys: String, CodingKey {
            case url
        }
        
        let url: URL
    }
}
