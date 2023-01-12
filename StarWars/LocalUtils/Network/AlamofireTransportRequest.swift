//
//  AlamofireTransportRequest.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.01.2023.
//

import Alamofire
import Foundation
import Miji
import SwiftyJSON

class AlamofireTransportRequest<T: HTTPRequestInput>: RequestTransport<T> {
    private let cachePrefix = "CACHED_REQUEST_"
    private let cacheDatePrefix = "CACHED_REQUEST_DATE_"

    weak var dataSource: RequestDataSource?

    var cacheOptions: CacheOptions? { (input as? CachedRequestInput)?.cacheOptions }
    private var cacheTimeInterval: CacheTimeInterval? { cacheOptions?.0 }
    private var cacheKey: String? { cacheOptions?.1 }

    private var dataTransformer: DataTransformer? { (input as? DataTransformableRequestInput)?.dataTransformer }

    private var serverAddress: String {
        return dataSource?.requestServerAddress(self) ?? "<NO SERVER ADDRESS>"
    }

    private var keepAliveAfterCompletion = false

    override public func perform(completion: ((Error?, Any?) -> Void)?) {
        if performCache(completion) == false {
            performActualRequest(completion)
        }
    }

    private func performCache(_ completion: ((Error?, Any?) -> Void)?) -> Bool {
        guard let cacheTimeInterval else { return false }
        guard let cacheKey else { return false }
        let keyDate = "\(cacheDatePrefix)\(cacheKey)"
        let cacheDate: TimeInterval = UserDefaults.standard.double(forKey: keyDate)

        let timeDiff = Date().timeIntervalSince1970 - cacheDate

        switch cacheTimeInterval {
        case let .timeInterval(timeInterval):
            guard timeDiff < timeInterval else {
                return false
            }
            return internalPerformCache(completion)

        case .returnCacheAndMakeRequest:
            keepAliveAfterCompletion = true
            _ = internalPerformCache(completion)
            return false
        }
    }

    private func internalPerformCache(_ completion: ((Error?, Any?) -> Void)?) -> Bool {
        guard let cacheKey else { return false }
        let key = "\(cachePrefix)\(cacheKey)"
        guard let cache = UserDefaults.standard.string(forKey: key) else { return false }
        guard let json = Utils().loadJSON(jsonString: cache) else { return false }
        let verbose = "⭐️⭐️⭐️ CACHED Request Address:\(input.endpoint()) key: \(key)\nCached response: \(json)"
        Log(verbose)
        completion?(nil, json)
        return true
    }

    private func performActualRequest(_ completion: ((Error?, Any?) -> Void)?) {
        switch input.type() {
        case .GET:
            performGetRequest(completion)

        case .POST:
            performPostRequest(completion)

        case .PATCH:
            performPatchRequest(completion)
        }
    }

    private func performPatchRequest(_ completion: ((Error?, Any?) -> Void)?) {
        let endpoint = input.endpoint()
        var address = "\(serverAddress)\(endpoint)"
        var queryString = ""
        do {
            queryString = try input.query().asQueryString()
        }
        catch {
            completion?(error, nil)
            return
        }

        if queryString.count > 0 {
            address += "?\(queryString)"
        }
        let headers = Alamofire.HTTPHeaders(input.headers())
        let body = input.body()

        Network.shared.patch(
            address: address,
            parameters: body,
            headers: headers,
            legacyCall: false
        ) { [weak self] json, error, _ in
            guard let self else { return }
            self.keepAliveAfterCompletion = false
            if let error = error {
                completion?(error, nil)
                return
            }

            if let cacheKey = self.cacheKey,
               let rawJsonString = json?.rawString()
            {
                let key = "\(self.cachePrefix)\(cacheKey)"
                let keyDate = "\(self.cacheDatePrefix)\(cacheKey)"

                UserDefaults.standard.set(
                    rawJsonString,
                    forKey: key
                )
                UserDefaults.standard.set(
                    Date().timeIntervalSince1970,
                    forKey: keyDate
                )
            }

            completion?(nil, json)
        }
    }

    private func performGetRequest(_ completion: ((Error?, Any?) -> Void)?) {
        let endpoint = input.endpoint()
        var address = "\(serverAddress)\(endpoint)"

        if input.isDirectAddress() {
            address = input.endpoint()
        }

        var queryString = ""
        do {
            queryString = try input.query().asQueryString()
        }
        catch {
            completion?(error, nil)
            return
        }

        if queryString.count > 0 {
            address += "?\(queryString)"
        }
        let headers = Alamofire.HTTPHeaders(input.headers())

        Network.shared.get(
            address: address,
            headers: headers,
            legacyCall: false,
            dataTransformer: dataTransformer
        ) { [weak self] json, error, _ in
            guard let self else { return }
            self.keepAliveAfterCompletion = false
            if let error = error {
                completion?(error, nil)
                return
            }

            if let cacheKey = self.cacheKey,
               let rawJsonString = json?.rawString()
            {
                let key = "\(self.cachePrefix)\(cacheKey)"
                let keyDate = "\(self.cacheDatePrefix)\(cacheKey)"

                UserDefaults.standard.set(
                    rawJsonString,
                    forKey: key
                )
                UserDefaults.standard.set(
                    Date().timeIntervalSince1970,
                    forKey: keyDate
                )
            }

            completion?(nil, json)
        }
    }

    private func performPostRequest(_ completion: ((Error?, Any?) -> Void)?) {
        let endpoint = input.endpoint()
        var address = "\(serverAddress)\(endpoint)"
        var queryString = ""
        do {
            queryString = try input.query().asQueryString()
        }
        catch {
            completion?(error, nil)
            return
        }

        if queryString.count > 0 {
            address += "?\(queryString)"
        }
        let headers = Alamofire.HTTPHeaders(input.headers())
        let body = input.body()

        Network.shared.post(
            address: address,
            parameters: body,
            headers: headers
        ) { [weak self] json, error, _ in
            guard let self else { return }
            self.keepAliveAfterCompletion = false
            if let error = error {
                completion?(error, nil)
                return
            }

            if let cacheKey = self.cacheKey,
               let rawJsonString = json?.rawString()
            {
                let key = "\(self.cachePrefix)\(cacheKey)"
                let keyDate = "\(self.cacheDatePrefix)\(cacheKey)"

                UserDefaults.standard.set(
                    rawJsonString,
                    forKey: key
                )
                UserDefaults.standard.set(
                    Date().timeIntervalSince1970,
                    forKey: keyDate
                )
            }

            completion?(nil, json)
        }
    }

    deinit {
        debugPrint("deinit \(self)")
    }
}

extension AlamofireTransportRequest: BagDestroyableItem {
    func bagShouldDestroyItem(_: Bag) -> Bool {
        return !keepAliveAfterCompletion
    }
}
