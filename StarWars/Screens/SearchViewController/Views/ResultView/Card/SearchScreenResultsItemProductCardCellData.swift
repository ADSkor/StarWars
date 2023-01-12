//
//  SearchScreenResultsItemProductCardCellData.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 09.01.2023.
//  Copyright © 2022 ADSkor. All rights reserved.
//

import Miji
import UIKit

class SearchScreenResultsItemProductCardCellData: TableViewAdapterItemData {
    private(set) weak var delegate: SearchScreenResultsItemProductCardCellDelegate?

    let value: String
    let isClickable: Bool

    init(
        value: String,
        isClickable: Bool,
        delegate: SearchScreenResultsItemProductCardCellDelegate?
    ) {
        self.value = value
        self.isClickable = isClickable
        self.delegate = delegate
    }
}
