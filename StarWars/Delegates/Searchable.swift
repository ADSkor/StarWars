//
//  Searchable.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 10.01.2023.
//

import Foundation

protocol Searchable {
    func contains(_ text: String) -> Bool
}
