//
//  API.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation

import Miji

protocol API: AnyObject {
    typealias GetSWRequest = Request<GetSWRequestInput, GetSWRequestOutput>
    func getSW(
        _ input: GetSWRequestInput
    ) -> GetSWRequest
}
