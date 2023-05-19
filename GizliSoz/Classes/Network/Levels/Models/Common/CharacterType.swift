//
//  CharacterType.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 13.05.2023.
//

import Foundation

enum CharacterType: String, Codable {
    case cyrillic
    case latin
    
    var text: String {
        switch self {
        case .cyrillic:
            return "cyrillic (АБВ)"
        case .latin:
            return "latin (ABC)"
        }
    }
}
