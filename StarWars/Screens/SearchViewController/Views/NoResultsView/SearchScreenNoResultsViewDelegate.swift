//
//  SearchScreenNoResultsViewDelegate.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 09.01.2023.
//

import Foundation

protocol SearchScreenNoResultsViewDelegate: AnyObject {
    func searchScreenNoResultsView(
        _ view: SearchScreenNoResultsView,
        didTapOn example: String
    )
}
