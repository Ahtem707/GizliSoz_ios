//
//  BuildConfig.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

struct BuildConfig {
    
    // TODO: - Версия сервера 1.0.0
    static let baseUrl: String = {
//        return "http://sitzhalilov.a.i.2.19.fvds.ru:3002/api/"
//        return "http://82.146.49.164:8005/"
        return "http://127.0.0.1:8005/"
    }()
    
    static let loggingEnabled: Bool = {
        #if PRODUCTION
            return false
        #elseif DEBUG
            return true
        #else
            return true
        #endif
    }()
}
