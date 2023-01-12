//
//  SearchScreenTextFieldViewDelegate.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Foundation

protocol SearchScreenTextFieldViewDelegate: AnyObject {
    func searchScreenTextFieldViewDidBeginEditing(_ view: SearchScreenTextFieldView)
    func searchScreenTextFieldViewDidTapSearchButton(_ view: SearchScreenTextFieldView, text: String)
    func searchScreenTextFieldViewDidTapBackButton(_ view: SearchScreenTextFieldView)
    func searchScreenTextFieldViewTextDidChange(_ view: SearchScreenTextFieldView, text: String)
}
