//
//  SearchScreenRecentRequestsView.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Miji
import UIKit

class SearchScreenRecentRequestsView: XibView {
    weak var delegate: SearchScreenRecentRequestsViewDelegate?

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var cardsView: AutosizingCardsView?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
    }

    func set(recentRequests: [String]) {
        titleLabel?.isHidden = recentRequests.count < 1
        let items = recentRequests.map {
            SearchScreenRecentRequestsViewCell.item(
                text: $0
            )
        }

        cardsView?.set(
            items: items,
            delegate: self
        )
    }
}

extension SearchScreenRecentRequestsView: CollectionViewAdapterDelegate {
    func collectionViewAdapter(adapter _: CollectionViewAdapter, didSelectCell _: CollectionViewAdapterCell, item: CollectionCellItem) {
        if let data = item.data as? SearchScreenRecentRequestsViewCellData {
            delegate?.searchScreenRecentRequestsView(self, didTapOnRecentRequest: data.text)
        }
    }
}
