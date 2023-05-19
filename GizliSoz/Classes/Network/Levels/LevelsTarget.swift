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
        case getLevels(_ input: LevelsRequest)
        
        // MARK: - Internal
        
        var path: String {
            switch self {
            case .checkConnect:
                return "checkConnect"
            case .appInit:
                return "appInit"
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
            case .checkConnect: return [:]
            case .appInit: return [:]
            case .getLevels(let input):
                return [
                    "levelsNumber": input.levelsNumber.join(),
                    "translateLang": input.translateLang,
                    "voiceoverActor": input.voiceoverActor,
                    "characterType": input.characterType
                ]
            }
        }
        
        var body: Data {
            return Data()
        }
        
        var sampleData: Data {
            switch self {
            case .checkConnect:
                return Data.json(fileName: "checkConnect", with: .json)
            case .appInit:
                return Data.json(fileName: "appInit", with: .json)
            case .getLevels:
                return Data.json(fileName: "levels", with: .json)
            }
        }
    }
}
