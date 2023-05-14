//
//  LevelsTarget.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

extension API {
    enum Levels: Target {
        
        case appInit
        case getLevel(_ input: LevelRequest)
        case getLevels
        
        // MARK: - Internal
        
        var path: String {
            switch self {
            case .appInit:
                return "appInit"
            case .getLevel:
                return "getLevel"
            case .getLevels:
                return "getLevels"
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var headers: [String : Any] {
            return [:]
        }
        
        var query: [String : Any] {
            switch self {
            case .appInit: return [:]
            case .getLevel(let input): return input.asDictionary()
            case .getLevels: return [:]
            }
        }
        
        var body: Data {
            return Data()
        }
        
        var sampleData: Data {
            switch self {
            case .appInit:
                return Data.json(fileName: "appInit", with: .json)
            case .getLevel:
                return Data.json(fileName: "level", with: .json)
            case .getLevels:
                return Data.json(fileName: "", with: .json)
            }
        }
    }
}
