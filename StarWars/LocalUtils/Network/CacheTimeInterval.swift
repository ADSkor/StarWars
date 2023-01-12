//
//  CacheTimeInterval.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.01.2023.
//

import Foundation

enum CacheTimeInterval {
    case timeInterval(_: TimeInterval)
    case returnCacheAndMakeRequest
}

typealias CacheOptions = (CacheTimeInterval, String)
