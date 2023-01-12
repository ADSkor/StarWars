//
//  UserDelegate.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation

protocol UserDelegate: AnyObject {
    func user(_ user: User, didChangeSearch text: String)
}

extension UserDelegate {
    func user(_: User, didChangeSearch _: String) {}
}
