//
//  SemiAPI.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation
import Miji

class SemiAPI: API {
    private let context: Context
    private lazy var mockAPI = MockAPI(context: self.context)
    private lazy var backendAPI = BackendAPI(context: self.context)

    @PersistentGlobalVariable(SemiAPIFlags.MOCK_GET_STAR_WARS.rawValue, false)
    private var mockGetSWEnabled: Bool

    init(context: Context) {
        self.context = context
    }
    
    func getSW(_ input: GetSWRequestInput) -> GetSWRequest {
        return mockGetSWEnabled ? mockAPI.getSW(input) : backendAPI.getSW(input)
    }
}
