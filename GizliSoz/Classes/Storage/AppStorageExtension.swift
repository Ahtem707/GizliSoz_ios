//
//  AppStorageExtension.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 03.01.2023.
//

import Foundation

extension UserDefaults {
    fileprivate static let shared: UserDefaults = {
        do {
            let bundleId = try Bundle.main.bundleIdentifier.!!
            let appGroup = "group.\(bundleId)"
            return try UserDefaults(suiteName: appGroup).!!
        } catch {
            return UserDefaults.standard
        }
    }()
}

@propertyWrapper
struct UserDefault<T: Codable> {
    
    private var key: String
    private var defaultValue: T
    
    init(_ key: String, _ defaultValue: T) {
        precondition(!key.isEmpty)
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            if let data = UserDefaults.shared.object(forKey: key) as? Data,
                let result = try? JSONDecoder().decode(T.self, from: data) {
                return result
            }
            return defaultValue
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.shared.set(encoded, forKey: key)
            }
        }
    }
}
