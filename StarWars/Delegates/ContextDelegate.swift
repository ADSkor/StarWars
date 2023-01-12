//
//  ContextDelegate.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 02.11.2022.
//

import Foundation

protocol ContextDelegate: AnyObject {
    func context(_ context: Context, didUpdateUser: User?)
}

extension ContextDelegate {
    func context(_: Context, didUpdateUser _: User?) {}
}
