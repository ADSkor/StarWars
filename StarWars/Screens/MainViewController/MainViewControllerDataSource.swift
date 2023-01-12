//
//  MainViewControllerDataSource.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 04.01.2023.
//

import Foundation

protocol MainViewControllerDataSource: AnyObject {
    var performerDelegate: PerformerDelegate? { get }
}
