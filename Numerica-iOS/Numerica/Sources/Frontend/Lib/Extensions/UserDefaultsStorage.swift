//
//  UserDefaultsStorage.swift
//  Numerica
//
//  Created by Emil Shpeklord on 06.10.2024.
//

import Foundation

@propertyWrapper
struct UserDefaultsStorage<T: Any> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
