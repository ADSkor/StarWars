//
//  SearchScreenResultsItemProductCardCellDelegate.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 09.01.2023.
//  Copyright © 2022 ADSkor. All rights reserved.
//

import Foundation

protocol SearchScreenResultsItemProductCardCellDelegate: AnyObject {
    func searchScreenResultsItemProductCardCell(
        _ cell: SearchScreenResultsItemProductCardCell,
        didSelectElement value: String
    )
}
