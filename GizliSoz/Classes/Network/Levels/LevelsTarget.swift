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
        case getWordSound(_ input: LevelSoundRequest)
        
        // MARK: - Internal
        
        var path: String {
            switch self {
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
            case .getLevels:
                return [:]
            case .getWordSound(let input):
                return [
                    "wordId" : input.wordId,
                    "voiceActor" : input.voiceActor
                ]
            }
        }
        
        var body: Data {
            return Data()
        }
        
        var sampleData: Data {
            switch self {
            case .getLevels:
                return Data.json(fileName: "levels", with: .json)
            case .getWordSound:
                return Data.json(fileName: "wordSound", with: .json)
            }
        }
    }
}
