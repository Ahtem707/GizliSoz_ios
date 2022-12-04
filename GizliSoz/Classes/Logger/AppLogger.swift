//
//  AppLogger.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

final class AppLogger {
    
    private static var enableLogType: [LogType] = [
//        .api, .api_mock,
        .storage
    ]
    
    static func log(_ type: LogType, _ message: Any) {
        if BuildConfig.loggingEnabled && Self.enableLogType.contains(type) {
            print("AppLogger> \(type.rawValue):",message)
        }
    }
}

// MARK: - LogType
extension AppLogger {
    enum LogType: String {
        case api, api_mock
        case storage
    }
}
