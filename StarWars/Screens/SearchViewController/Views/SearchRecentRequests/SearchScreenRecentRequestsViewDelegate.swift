//
//  SearchScreenRecentRequestsViewDelegate.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Foundation

protocol SearchScreenRecentRequestsViewDelegate: AnyObject {
    func searchScreenRecentRequestsView(
        _ view: SearchScreenRecentRequestsView,
        didTapOnRecentRequest: String
    )
}
