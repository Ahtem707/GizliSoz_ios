//
//  AppInitRequest.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 19.05.2023.
//

import Foundation

struct AppInitRequest: Codable {
    
    enum CodingKeys: String, CodingKey {
        case appVersion
    }
    
    let appVersion: String
}
