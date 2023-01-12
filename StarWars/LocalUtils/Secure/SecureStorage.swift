//
//  SecureStorage.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation


protocol SecureStorage {
    func set(key: String, value: String) throws
    func get(key: String) throws -> String?
    func remove(key: String)
    func removeAll() throws
}
