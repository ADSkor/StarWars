//
//  SearchScreenNoResultsView.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Miji
import UIKit

class SearchScreenNoResultsView: XibView {
    
    @IBOutlet private weak var topLabel: UILabel?
    @IBOutlet private weak var backgroundView: UIView?
    @IBOutlet private weak var tableView: TableView?

    weak var delegate: SearchScreenNoResultsViewDelegate?
    
    func set(
        searchText: String,
        examples: [String],
        delegate: SearchScreenNoResultsViewDelegate
    ) {
        backgroundView?.backgroundColor = .white
        let items = PlaceholderExamples.search(
            searchText: searchText,
            examples: examples,
            view: self
        )
        tableView?.fill(items)
        topLabel?.text = "No results for \"\(searchText)\", try one of this:"
    }
}

extension SearchScreenNoResultsView: SearchScreenNoResultsViewExampleDelegate {
    func searchScreenNoResultsViewExampleDidPressed(_ cell: SearchScreenNoResultsViewExample, example: String) {
        delegate?.searchScreenNoResultsView(self, didTapOn: example)
    }
}
