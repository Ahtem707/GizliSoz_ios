//
//  AppLogger.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation
import os

final class AppLogger {
    
    private static var enableLogType: [LogType] = [
        .api, .api_mock,
        .storage
    ]
    
    static func log(_ type: LogType, _ message: Any) {
        guard BuildConfig.loggingEnabled && Self.enableLogType.contains(type) else { return }
        guard let message = message as? String else { return }
        let log = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: type.rawValue)
        )
        log.notice("\(message, privacy: .public)")
    }
    
    static func warning(_ type: LogType, _ message: Any) {
        guard BuildConfig.loggingEnabled && Self.enableLogType.contains(type) else { return }
        guard let message = message as? String else { return }
        let log = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: type.rawValue)
        )
        log.warning("\(message, privacy: .public)")
    }
    
    static func error(_ type: LogType, _ message: Any) {
        guard BuildConfig.loggingEnabled && Self.enableLogType.contains(type) else { return }
        guard let message = message as? String else { return }
        let log = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: type.rawValue)
        )
        log.error("\(message, privacy: .public)")
    }
    
    static func critical(_ type: LogType, _ message: Any) {
        guard BuildConfig.loggingEnabled && Self.enableLogType.contains(type) else { return }
        guard let message = message as? String else { return }
        let log = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: type.rawValue)
        )
        log.critical("\(message, privacy: .public)")
    }
}

// MARK: - LogType
extension AppLogger {
    enum LogType: String {
        case api, api_mock
        case storage
    }
}
