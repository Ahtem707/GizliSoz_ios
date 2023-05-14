//
//  ApiResponse.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 12.05.2023.
//

import Foundation

struct ApiResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case result
        case description
    }
    
    let result: Int
    let description: String?
}
