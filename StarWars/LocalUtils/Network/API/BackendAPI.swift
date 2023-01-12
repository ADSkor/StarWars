//
//  BackendAPI.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation
import Miji
import SwiftyJSON

class BackendAPI: API {
    private let context: Context

    init(
        context: Context
    ) {
        self.context = context
    }
    
    func getSW(_ input: GetSWRequestInput) -> GetSWRequest {
        let transport = AlamofireTransportRequest<GetSWRequestInput>(input)
        transport.dataSource = self
        
        let request = GetSWRequest(input, transport)
        return request
    }
}

extension BackendAPI: RequestDataSource {
    func requestServerAddress(_: Any) -> String {
        return Network.mainServer
    }
}
