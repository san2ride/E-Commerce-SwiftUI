//
//  UserDefaults+Ext.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/3/25.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let userId = "userId"
    }
    var userId: Int? {
        get {
            let id = integer(forKey: Keys.userId)
            return id == 0 ? nil : id // return nil if userId hasn't been set
        }
        set {
            set(newValue, forKey: Keys.userId)
        }
    }
}
