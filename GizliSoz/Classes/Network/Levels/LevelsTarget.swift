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
        case getWordSound(_ input: LevelSoundRequest)
        
        // MARK: - Internal
        
        var path: String {
            switch self {
            case .appInit:
                return "appInit"
            case .getLevel:
                return "getLevel"
            case .getLevels:
                return "getLevels"
            case .getWordSound:
                return "wordSound"
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
            case .getWordSound(let input): return input.asDictionary()
            }
        }
        
        var body: Data {
            return Data()
        }
        
        var sampleData: Data {
            switch self {
            case .appInit:
                return Data.json(fileName: "", with: .json)
            case .getLevel:
                return Data.json(fileName: "", with: .json)
            case .getLevels:
                return Data.json(fileName: "levels", with: .json)
            case .getWordSound:
                return Data.json(fileName: "wordSound", with: .json)
            }
        }
    }
}
