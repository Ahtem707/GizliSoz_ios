//
//  AppInitResponse.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 12.05.2023.
//

import Foundation

struct AppInitResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case translationLangs
        case voiceoverActors
        case levelsCount
    }
    
    let translationLangs: [Parameter]
    let voiceoverActors: [Parameter]
    let levelsCount: Int
}
