//
//  PerformerDelegate.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 02.11.2022.
//

import Foundation
import Miji

public protocol PerformerDelegate: AnyObject {
    func popAllInnerScreens()
    func popToRoot()
}
