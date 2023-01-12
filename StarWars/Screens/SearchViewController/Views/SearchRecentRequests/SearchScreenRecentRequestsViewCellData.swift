//
//  SearchScreenRecentRequestsViewCellData.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Foundation
import Miji

class SearchScreenRecentRequestsViewCellData: CollectionViewAdapterItemData {
    let text: String

    init(text: String) {
        self.text = text
    }
}
