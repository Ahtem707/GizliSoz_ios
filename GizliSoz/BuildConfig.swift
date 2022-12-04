//
//  BuildConfig.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

struct BuildConfig {
    
    static let baseUrl: String = {
        return "http://sitzhalilov.a.i.2.19.fvds.ru:3002/api/"
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
