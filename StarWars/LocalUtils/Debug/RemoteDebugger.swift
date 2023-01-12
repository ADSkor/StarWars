//
//  RemoteDebugger.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation
import Miji

class RemoteDebugger {
    private let address: String

    init(
        address: String
    ) {
        self.address = address
    }

    func log(_ string: String) {
        guard isSimulator else { return }
        #if DEBUG
            debugPrint(address)
            debugPrint("Remote log: \(string)")
            Network.shared.post(
                address: address,
                parameters: ["message": string]
            ) { json, error, statusCode in
                debugPrint(error ?? "")
                debugPrint(json ?? "")
                debugPrint(statusCode ?? "")
                debugPrint("---")
            }
        #endif
    }
}
