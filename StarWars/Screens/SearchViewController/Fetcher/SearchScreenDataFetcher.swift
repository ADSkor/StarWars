//
//  SearchScreenDataFetcher.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 06.01.2023.
//

import Foundation
import SwiftyJSON
import Miji

class SearchScreenDataFetcher {
    weak var delegate: SearchScreenDataFetcherDelegate?

    private var fetchingInProgress = false
    private let context: Context

    private let bag: Bag = .init()

    init(
        context: Context,
        delegate: SearchScreenDataFetcherDelegate?
    ) {
        self.context = context
        self.delegate = delegate
    }

    func fetch(endpointString: String) {
        guard !fetchingInProgress else { return }
        fetchingInProgress = true
        
        context.api.getSW(
            GetSWRequestInput(
                endpointString: endpointString,
                cacheOptions: (.timeInterval(.Hours(2)), endpointString)
            )
        )
        .perform(bag) { [weak self] output in
            guard let self else { return }
            self.fetchingInProgress = false
            if let error = output.error {
                self.delegate?.searchScreenDataFetcher(self, didFetch: error)
            }
            guard let payload = output.payload else { return }
            self.delegate?.searchScreenDataFetcher(self, didFetch: payload.json)
        }
    }
}

protocol SearchScreenDataFetcherDelegate: AnyObject {
    func searchScreenDataFetcher(
        _ fetcher: SearchScreenDataFetcher,
        didFetch json: JSON
    )

    func searchScreenDataFetcher(
        _ fetcher: SearchScreenDataFetcher,
        didFetch error: Error?
    )
}
