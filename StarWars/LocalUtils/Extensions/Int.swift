//
//  Int.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 07.11.2022.
//

import Foundation

extension Int {
    func asString() -> String {
        return String(self)
    }

    func asStringMoreThanZeroOrNil() -> String? {
        if self < 1 {
            return nil
        }
        return asString()
    }

    static func stringOrDefault(_ int: Int?, defaultText: String = "-") -> String {
        if let int = int {
            return "\(int)"
        }
        else {
            return defaultText
        }
    }
}
