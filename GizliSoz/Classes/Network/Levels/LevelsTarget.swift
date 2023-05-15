//
//  LevelsTarget.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

extension API {
    enum Levels: Target {
        
        case checkConnect
        case appInit
        case getLevel(_ input: LevelRequest)
        
        // MARK: - Internal
        
        var path: String {
            switch self {
            case .checkConnect:
                return "checkConnect"
            case .appInit:
                return "appInit"
            case .getLevel:
                return "getLevel"
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
            case .checkConnect: return [:]
            case .appInit: return [:]
            case .getLevel(let input): return input.asDictionary()
            }
        }
        
        var body: Data {
            return Data()
        }
        
        var sampleData: Data {
            switch self {
            case .checkConnect:
                return Data.json(fileName: "", with: .json)
            case .appInit:
                return Data.json(fileName: "appInit", with: .json)
            case .getLevel:
                return Data.json(fileName: "level", with: .json)
            }
        }
    }
}
