//
//  SearchScreenRecentRequestsViewCell.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Miji
import UIKit

class SearchScreenRecentRequestsViewCell: CollectionViewAdapterCell {
    @IBOutlet private weak var textLabel: UILabel?
    @IBOutlet private weak var backView: UIView?

    static func item(text: String) -> CollectionViewAdapterItem<CollectionViewAdapterCell, CollectionViewAdapterItemData> {
        return CollectionViewAdapterItem(
            cellClass: SearchScreenRecentRequestsViewCell.self as CollectionViewAdapterCell.Type,
            data: SearchScreenRecentRequestsViewCellData(text: text)
        )
    }

    @IBAction private func didTap(button _: UIButton?) {
        delegate?.collectionViewAdapterCellDidTap(self)
    }

    override func fill(data: CollectionViewAdapterItemData) {
        guard let data = data as? SearchScreenRecentRequestsViewCellData else { return }

        backView?.backgroundColor = .systemGray3
        backView?.layer.cornerRadius = 12

        textLabel?.text = String(data.text.prefix(30))
        guard data.text.count > 30 else { return }
        guard let txt = textLabel?.text else { return }
        textLabel?.text = txt + "..."
    }
}
