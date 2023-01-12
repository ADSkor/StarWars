//
//  SearchScreenResultsViewDelegate.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 09.01.2023.
//  Copyright © 2022 ADSkor. All rights reserved.
//

import Foundation
import Miji

protocol SearchScreenResultsViewDelegate: AnyObject {
    func SearchScreenResultsViewDidTap(_ view: SearchScreenResultsView, https: String)
    func SearchScreenResultsViewPreviousDidTap(_ view: SearchScreenResultsView, https: String?)
    func SearchScreenResultsViewNextDidTap(_ view: SearchScreenResultsView, https: String?)
}
