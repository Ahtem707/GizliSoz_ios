//
//  LevelResponse.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import Foundation

struct LevelResponse: Codable {
    
    enum CodingKeys: String, CodingKey {
        case result
        case description
        case content
    }
    
    let result: Int
    let description: String?
    let content: [Content]?
}

extension LevelResponse {
    struct Content: Codable {
        enum CodingKeys: String, CodingKey {
            case level
            case name
            case size
            case chars
            case words
            case bonusWords
        }
        
        let level: Int
        let name: String
        let size: Int
        let chars: [String]
        let words: [String : Word]
        let bonusWords: [String]
    }
}

extension LevelResponse {
    struct Word: Codable {
        enum CodingKeys: String, CodingKey {
            case id
            case x
            case y
            case chars
            case description
            case sound
        }
        
        let id: Int
        let x: [Int]
        let y: [Int]
        let chars: [String]
        let description: String
        let sound: Bool
    }
}
