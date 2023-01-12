//
//  MockAPI.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation
import Miji

class MockAPI: API {
    private let context: Context

    init(
        context: Context
    ) {
        self.context = context
    }

    func getSW(_ input: GetSWRequestInput) -> GetSWRequest {
        return Request(input, MockupTransportRequest<GetSWRequestInput>(input))
    }
}
