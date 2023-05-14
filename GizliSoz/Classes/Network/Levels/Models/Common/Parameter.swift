//
//  Parameter.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 13.05.2023.
//

import Foundation

struct Parameter: Codable {
    enum CodingKeys: String, CodingKey {
        case code
        case value
        case isDefault
    }

    let code: String
    let value: String
    let isDefault: Bool
}
