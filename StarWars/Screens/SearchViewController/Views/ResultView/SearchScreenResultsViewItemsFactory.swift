//
//  SearchScreenResultsViewItemsFactory.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 09.01.2023.
//  Copyright © 2022 ADSkor. All rights reserved.
//

import Miji
import UIKit

class SearchScreenResultsViewItemsFactory {
    static func items(
        results: [[String:Any]]?,
        resultsView: SearchScreenResultsView
    ) -> [CellItem] {
        var items: [CellItem] = []
        
        guard let results else { return items }
        results.forEach { result in
            for (key,value) in result {
                let typeString = TypeOf(value: value)
                switch typeString {
                case "Array":
                    guard value is [String] else { continue } //to be sure about downcast later
                    items.append(
                        TextCell.item(text: key + ":")
                    )
                    if let arrayOfString = value as? [String] {
                        if arrayOfString.isNotEmpty {
                            for item in arrayOfString {
                                let isClickable = item.contains("https://swapi.dev/api")
                                items.append(
                                    EmptySpaceCell.item(
                                        height: 8
                                    )
                                )
                                items.append(
                                    SearchScreenResultsItemProductCardCell.item(
                                        value: item,
                                        isClickable: isClickable,
                                        delegate: resultsView)
                                )
                            }
                        } else {
                            items.append(
                                EmptySpaceCell.item(
                                    height: 8
                                )
                            )
                            items.append(
                                SearchScreenResultsItemProductCardCell.item(
                                    value: "*Empty*",
                                    isClickable: false,
                                    delegate: resultsView)
                            )
                        }
                    }
                    
                case "Dictionary":
                    guard value is [String: String] else { continue } //to be sure about downcast later
                    items.append(
                        TextCell.item(text: key + ":")
                    )
                    for item in value as! [String: String] {
                        items.append(
                            EmptySpaceCell.item(
                                height: 8
                            )
                        )
                        items.append(
                            SearchScreenResultsItemProductCardCell.item(
                                value: "\(item.key):\(item.value)",
                                isClickable: false,
                                delegate: resultsView)
                        )
                    }
                case "NotUsual":
                    continue
                default:
                    items.append(
                        TextCell.item(text: key + ":")
                    )
                    let stringValue = (value as? String) ?? "can't recognize text value for \(key)"
                    let isClickable = stringValue.contains("https://swapi.dev/api")
                    items.append(
                        SearchScreenResultsItemProductCardCell.item(
                            value: stringValue,
                            isClickable: isClickable,
                            delegate: resultsView)
                    )
                }
            }
        }
        
        return items
    }
}
