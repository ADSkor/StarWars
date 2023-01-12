//
//  KeychanStorage.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation
import SwiftKeychainWrapper

class KeychainStorage {
    static let standard = KeychainStorage()
}

extension KeychainStorage: SecureStorage {
    func set(key: String, value: String) throws {
        guard KeychainWrapper.standard.set(value, forKey: key) == true else {
            throw NSError.error(
                domain: "Secure Storage",
                code: 2,
                localizedDescription: "Secure storage write error"
            )
        }
    }

    func get(key: String) throws -> String? {
        return KeychainWrapper.standard.string(forKey: key)
    }

    func remove(key: String) {
        KeychainWrapper.standard.removeObject(forKey: key)
    }

    func removeAll() throws {
        KeychainWrapper.standard.removeAllKeys()
    }
}
