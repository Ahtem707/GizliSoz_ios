//
//  AppStorageExtension.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 03.01.2023.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private var key: String
    private var defaultValue: T
    
    init(_ key: String, _ defaultValue: T) {
        precondition(!key.isEmpty)
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
