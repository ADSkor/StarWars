//
//  SearchScreenNoResultsViewPlaceholderExamplesFactory.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 09.01.2023.
//

import Miji

class PlaceholderExamples {
    @CellItemsBuilder static func search(
        searchText: String,
        examples: [String],
        view: SearchScreenNoResultsView
    ) -> [CellItem] {
        EmptySpaceCell.item(height: 24)
        for example in examples {
            SearchScreenNoResultsViewExample.item(
                example: example,
                delegate: view
            )
            EmptySpaceCell.item(height: 8)
        }
    }
}
