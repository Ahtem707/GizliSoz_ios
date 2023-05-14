//
//  AppLogger.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation
import os

final class AppLogger {
    
    // TODO: - Переделать
    private static var enableLogType: [LogType] = LogType.allCases
//    private static var enableLogType: [LogType] = [
//        .api, .api_mock,
//        .storage
//    ]
    
    static func log(_ type: LogType, _ message: Any) {
        guard BuildConfig.loggingEnabled && Self.enableLogType.contains(type) else { return }
        let message = decodeMessage(message)
        if #available(iOS 14.0, *) {
            let log = Logger(
                subsystem: Bundle.main.bundleIdentifier!,
                category: String(describing: type.rawValue)
            )
            log.notice("\(message, privacy: .public)")
        } else {
            let log = OSLog(
                subsystem: Bundle.main.bundleIdentifier!,
                category: String(describing: type.rawValue)
            )
            os_log("%@", log: log, type: .info, message)
        }
    }
    
    static func warning(_ type: LogType, _ message: Any) {
        guard BuildConfig.loggingEnabled && Self.enableLogType.contains(type) else { return }
        let message = decodeMessage(message)
        if #available(iOS 14.0, *) {
            let log = Logger(
                subsystem: Bundle.main.bundleIdentifier!,
                category: String(describing: type.rawValue)
            )
            log.warning("\(message, privacy: .public)")
        } else {
            let log = OSLog(
                subsystem: Bundle.main.bundleIdentifier!,
                category: String(describing: type.rawValue)
            )
            os_log("%@", log: log, type: .fault, message)
        }
    }
    
    static func error(_ type: LogType, _ message: Any) {
        guard BuildConfig.loggingEnabled && Self.enableLogType.contains(type) else { return }
        let message = decodeMessage(message)
        if #available(iOS 14.0, *) {
            let log = Logger(
                subsystem: Bundle.main.bundleIdentifier!,
                category: String(describing: type.rawValue)
            )
            log.error("\(message, privacy: .public)")
        } else {
            let log = OSLog(
                subsystem: Bundle.main.bundleIdentifier!,
                category: String(describing: type.rawValue)
            )
            os_log("%@", log: log, type: .error, message)
        }
    }
    
    static func critical(_ type: LogType, _ message: Any) {
        guard BuildConfig.loggingEnabled && Self.enableLogType.contains(type) else { return }
        let message = decodeMessage(message)
        if #available(iOS 14.0, *) {
            let log = Logger(
                subsystem: Bundle.main.bundleIdentifier!,
                category: String(describing: type.rawValue)
            )
            log.critical("\(message, privacy: .public)")
        } else {
            let log = OSLog(
                subsystem: Bundle.main.bundleIdentifier!,
                category: String(describing: type.rawValue)
            )
            os_log("%@", log: log, type: .error, message)
        }
    }
}

extension AppLogger {
    /// Преобразует текст сообщения в правильный формат
    /// - Parameter message: Текст сообщения
    /// - Returns: Возвращает сообщение в строковом типе
    private static func decodeMessage(_ message: Any) -> String {
        if let message = message as? AppError {
            return message.localizedDescription
        } else if let message = message as? String {
            return message
        } else {
            return String(describing: message)
        }
    }
}

// MARK: - LogType
extension AppLogger {
    enum LogType: String, CaseIterable {
        case api, api_mock
        case storage
        case logic
        case fetch
        case media
    }
}
