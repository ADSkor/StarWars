//
//  GetSWRequest.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.01.2023.
//

import Foundation
import Miji

class GetSWRequestInput: CachedRequestInput {
    let endpointString: String
    let cacheOptions: CacheOptions?

    init(
        endpointString: String,
        cacheOptions: CacheOptions?
    ) {
        self.endpointString = endpointString
        self.cacheOptions = cacheOptions
    }
}

extension GetSWRequestInput: HTTPRequestInput {
    func headers() -> HTTPHeaders {
        [:]
    }

    func endpoint() -> String {
        return endpointString
    }

    func type() -> HTTPRequestType {
        return .GET
    }
}
