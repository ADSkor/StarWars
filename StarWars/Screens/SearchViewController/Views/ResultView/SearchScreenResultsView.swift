//
//  SearchScreenResultsView.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 09.01.2023.
//  Copyright © 2022 ADSkor. All rights reserved.
//

import Miji
import UIKit

class SearchScreenResultsView: XibView {
    weak var delegate: SearchScreenResultsViewDelegate?

    @IBOutlet private weak var nextButton: UIButton?
    @IBOutlet private weak var previousButton: UIButton?
    @IBOutlet private weak var tableView: UITableView?

    private let tableViewAdapter = TableViewAdapter()
    @IBOutlet private weak var tableViewTopConstarint: NSLayoutConstraint?
    
    private var nextPage: String?
    private var previousPage: String?
    
    func set(
        nextPage: String?,
        previousPage: String?,
        results: [[String:Any]]?
    ) {
        self.nextPage = nextPage
        self.previousPage = previousPage
        
        let items = SearchScreenResultsViewItemsFactory.items(
            results: results,
            resultsView: self
        )
        nextButton?.isHidden = nextPage == nil
        previousButton?.isHidden = previousPage == nil
        tableViewTopConstarint?.constant = nextPage == nil && previousPage == nil ? 0 : 48

        tableViewAdapter.tableView = tableView
        tableViewAdapter.delegate = self

        tableViewAdapter.set(items: items)
    }
    
    
    @IBAction func previousButtonDidPressed(_ sender: UIButton) {
        delegate?.SearchScreenResultsViewPreviousDidTap(self, https: previousPage)
    }
    
    @IBAction func nextButtonDidPressed(_ sender: UIButton) {
        delegate?.SearchScreenResultsViewNextDidTap(self, https: nextPage)
    }
    
    func scrollToTop() {
        tableViewAdapter.scrollToTop()
    }
}

extension SearchScreenResultsView: TableViewAdapterDelegate {
    func tableViewAdapter(adapter _: TableViewAdapter, didSelectCell _: TableViewAdapterCell, item _: CellItem) {
        debugPrint("We can use it directly from Cell and use any Data from inside")
    }
}

extension SearchScreenResultsView: SearchScreenResultsItemProductCardCellDelegate {
    func searchScreenResultsItemProductCardCell(_ cell: SearchScreenResultsItemProductCardCell, didSelectElement value: String) {
        delegate?.SearchScreenResultsViewDidTap(self, https: value)
    }
}
