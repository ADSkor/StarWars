//
//  EmptySpaceCell.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Miji
import UIKit

class EmptySpaceCell: TableViewAdapterCell {
    static func item(
        identifier: String = UUID().uuidString,
        backgroundColor: UIColor = .clear,
        height: CGFloat
    ) -> CellItem {
        return CellItem(
            identifier: identifier,
            cellClass: EmptySpaceCell.self,
            data: EmptySpaceCellData(
                backgroundColor: backgroundColor,
                emptySpace: height
            )
        )
    }

    override func fill(data: TableViewAdapterItemData) {
        guard let data = data as? EmptySpaceCellData else { return }
        backgroundColor = data.backgroundColor
    }
}
