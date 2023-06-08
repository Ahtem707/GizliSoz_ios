//
//  BuildConfig.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

struct BuildConfig {
    
    static let baseUrl: String = {
//        return "http://sitzhalilov.a.i.2.19.fvds.ru:3002/api/"
        #if PRODUCTION
            return "http://82.146.49.164:8005/"
        #elseif DEBUG
            return "http://82.146.49.164:8005/"
//            return "http://127.0.0.1:8005/"
        #else
            return "http://127.0.0.1:8005/"
        #endif
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
