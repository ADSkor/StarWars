//
//  SearchScreenNoResultsViewExampleData.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 09.01.2023.
//

import Foundation
import Miji

class SearchScreenNoResultsViewExampleData: TableViewAdapterItemData {
    private(set) weak var delegate: SearchScreenNoResultsViewExampleDelegate?
    var example: String
    
    init(
        example: String,
        delegate: SearchScreenNoResultsViewExampleDelegate?
    ) {
        self.example = example
        self.delegate = delegate
    }
}
