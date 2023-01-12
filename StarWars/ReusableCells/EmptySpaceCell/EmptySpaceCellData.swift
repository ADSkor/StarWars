//
//  EmptySpaceCellData.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Miji
import UIKit

class EmptySpaceCellData: TableViewAdapterItemData {
    let backgroundColor: UIColor
    let emptySpace: CGFloat

    init(backgroundColor: UIColor, emptySpace: CGFloat = 16) {
        self.backgroundColor = backgroundColor
        self.emptySpace = emptySpace
    }

    override func height() -> CGFloat {
        return emptySpace
    }
}
