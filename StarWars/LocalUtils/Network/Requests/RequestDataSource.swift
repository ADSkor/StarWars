//
//  RequestDataSource.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation

protocol RequestDataSource: AnyObject {
    func requestServerAddress(_ request: Any) -> String
}
