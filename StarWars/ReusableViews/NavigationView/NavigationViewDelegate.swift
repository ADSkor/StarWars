//
//  NavigationViewDelegate.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Foundation
import Miji

protocol NavigationViewDelegate: AnyObject {
    func navigationViewDidTapBack(_ view: NavigationView)
}
