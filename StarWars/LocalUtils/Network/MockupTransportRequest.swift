//
//  MockupTransportRequest.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.01.2023.
//

import Foundation
import Miji
import SwiftyJSON

class MockupTransportRequest<T: HTTPRequestInput>: RequestTransport<T> {
    override public func perform(completion: ((Error?, Any?) -> Void)?) {
        debugPrint("[MOCK COMPLETION]")
        let endpoint = input.endpoint()
        debugPrint(endpoint)

        let filename = endpoint.replacingOccurrences(of: "/", with: "_") + "_mock_response.json"
        let json = JSON.from(filename: filename)

        debugPrint("MOCK RESPONSE JSON FILENAME: \(filename)")
        completion?(nil, json)
    }
}
