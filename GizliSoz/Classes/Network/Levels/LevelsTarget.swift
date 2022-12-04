//
//  LevelsTarget.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

extension API {
    enum Levels: Target {
        
        case getLevels
        
        // MARK: - Internal
        
        var path: String {
            switch self {
            case .getLevels:
                return "crosswords"
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var headers: [String : String] {
            return [:]
        }
        
        var query: [String : String] {
            return [:]
        }
        
        var body: Data {
            return Data()
        }
        
        var sampleData: Data {
            switch self {
            case .getLevels:
                return Data.json(fileName: "levels", with: .json)
            }
        }
    }
}
