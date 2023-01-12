//
//  Network.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation
import Alamofire
import Miji
import SwiftyJSON

// Singleton
class Network {
    static let PROD = "https://swapi.dev/api/"

    private(set) static var mainServer = PROD

//    var apiURL: String { return "\(Self.mainServer)/api/" }

    static let shared = Network()

    private let bag = Bag()
    
    private func logRequest(
        type: String,
        requestDate: Date,
        endDate: Date,
        requestTime: TimeInterval,
        requestPerformance: String,
        address: String,
        headers: Alamofire.HTTPHeaders,
        parameters: Parameters,
        response: Any,
        statusCode: Int
    ) {
        var headers = headers
        var parameters = parameters
        var response = response

//        if TokenLoggingEnabled == false {
//            headers["Authorization"] = "<PRIVATE>"
//            headers["token"] = "<PRIVATE>"
//            parameters["refreshToken"] = "<PRIVATE>"
//
//            if address.contains("oauth/token") || address.contains("oauth/refresh") {
//                response = "<PRIVATE>"
//            }
//        }

        let verboseLine = "\n*\n*\n*\t\t📲 \(type.uppercased())_REQUEST\nSTART_DATE: \(requestDate)\nEND_DATE: \(endDate)\nREQUEST_TIME: \(requestTime)\nADAPTED_REQUEST_PERFORMANCE:  \(requestPerformance)\nAddress: \(address)\nHeaders: \(headers)\nparameters: \(parameters)\nResponse: \(response)\nStatus Code: \(statusCode)"

        Log(verboseLine)
    }

    func get(
        address: String,
        headers: Alamofire.HTTPHeaders = ["Content-Type": "application/json"],
        shouldHandleErrors: Bool = true,
        shouldHandleTimeout: Bool = true,
        shouldRefreshToken: Bool = true,
        session: Session = AF,
        legacyCall: Bool = true,
        logging: Bool = true,
        dataTransformer: DataTransformer? = nil,
        completion: ((JSON?, Error?, Int?) -> Void)?
    ) {
        var headers = headers

        let requestDate = Date()

        session.request(address, method: .get, headers: headers).responseData { response in

            let endDate = Date()
            let requestTime = endDate.timeIntervalSince1970 - requestDate.timeIntervalSince1970
            let requestPerformance = AdaptRequestTime(requestTime)

            if logging {
                self.logRequest(
                    type: "GET",
                    requestDate: requestDate,
                    endDate: endDate,
                    requestTime: requestTime,
                    requestPerformance: requestPerformance,
                    address: address,
                    headers: headers,
                    parameters: [:],
                    response: response,
                    statusCode: response.response?.statusCode ?? -1
                )
            }

            switch response.result {
            case let .success(value):
                var value = value
                if let dataTransformer = dataTransformer,
                   let transformedData = dataTransformer.transform(data: response.data)
                {
                    value = transformedData
                }

                let dataJSON = JSON(value)
                if let statusCode = response.response?.statusCode, statusCode != 200 {
                    let rawLocalizedDescription =
                        dataJSON["message"].string ??
                        dataJSON["error"].stringValue

                    let localizedDescription = rawLocalizedDescription.count > 0 ? rawLocalizedDescription : "Ошибка сервера: \(address.introOutro) (\(statusCode))"

                    if shouldHandleErrors {
                        if statusCode == 403 || statusCode == 401, shouldRefreshToken {
                            RemoteLog("--- ACCESS DENIED (SHOULD REFRESH TOKEN) ---")
                            let token = headers["Authorization"] ?? "<NO TOKEN> !!!"
                            RemoteLog("Token refresh error from address: \(address)")
                            RemoteLog("Token error for token: \(token.short)")
                            RemoteLog("---")
//                            self.refreshTokenOrDie(
//                                tries: Self.refreshTokenRetries,
//                                profile: profile,
//                                lastError: nil
//                            ) { error, profile in
//                                if let error = error {
//                                    completion?(nil, error, statusCode)
//                                    SendAuthorizationExpiredEvent(token: profile.backendInfo?.accessToken ?? "NONE")
//                                    let localizedDescription = error.localizedDescription
//                                    RemoteLog("--- TOKEN REFRESH FAILED ---")
//                                    RemoteLog("Token Refresh FAILED for original address: \(address)")
//                                    RemoteLog("Token Refresh Error: \(localizedDescription)")
//                                    RemoteLog("Token Refresh Error With Refresh Token: \(profile.backendInfo?.refreshToken.short ?? "<None>")")
//                                    RemoteLog("--- TOKEN REFRESH FAILED  END ---")
//                                }
//                                else {
//                                    RemoteLog("--- TOKEN REFRESH SUCCESS ---")
//                                    RemoteLog("Token Refresh SUCCESS for original address: \(address)")
//                                    RemoteLog("New token: \(profile.backendInfo?.accessToken.short ?? "<None>")")
//                                    RemoteLog("New refresh token: \(profile.backendInfo?.refreshToken.short ?? "<None>")")
//                                    RemoteLog("--- TOKEN REFRESH SUCCESS END ---")
//                                    self.get(
//                                        address: address,
//                                        headers: headers,
//                                        shouldHandleErrors: shouldHandleErrors,
//                                        profile: profile,
//                                        shouldRefreshToken: false,
//                                        session: session,
//                                        completion: completion
//                                    )
//                                }
//                            }
                        }
                        else {
                            if statusCode == 403 || statusCode == 401 {
                                RemoteLog("--- ACCESS DENIED (FULL STOP) ---")
                                let token = headers["Authorization"] ?? "<NO TOKEN> !!!"
                                RemoteLog("\(address)")
                                RemoteLog("\(token.short)")
                                RemoteLog("--- ACCESS DENIED (FULL STOP) END ---")
                            }

                            completion?(dataJSON, NSError.error(
                                domain: "Network",
                                code: statusCode,
                                localizedDescription: localizedDescription
                            ), statusCode)
                        }
                    }
                }
                else if let statusCode = response.response?.statusCode, statusCode == 200 {
                    completion?(dataJSON, nil, statusCode)
                }

            case let .failure(error):
                if shouldHandleTimeout {
                    switch error {
                    case .sessionTaskFailed(error: URLError.timedOut):
                        TimeoutRequestRetryFlowController.performGetIfCan(
                            address: address,
                            headers: headers,
                            shouldHandleErrors: shouldHandleErrors,
                            shouldRefreshToken: shouldRefreshToken,
                            session: session,
                            completion: completion
                        )
                    default:
                        completion?(nil, error, response.response?.statusCode)
                    }
                }
                else {
                    completion?(nil, error, response.response?.statusCode)
                }
            }
        }
    }

    func put(
        address: String,
        parameters: [String: Any] = [:],
        headers: Alamofire.HTTPHeaders = ["Content-Type": "application/json"],
        session: Session = AF,
        legacyCall: Bool = true,
        completion: @escaping (JSON?, Error?, Int?) -> Void
    ) {
//        if let token = profile?.token {
//            if legacyCall {
//                headers["token"] = "\(token)"
//            }
//            headers["Authorization"] = "Bearer \(token)"
//
//            if token.count < 1 {
//                Log("\n\n!!! TOKEN IS EMPTY (LENGTH < 1) !!!\n\n")
//            }
//        }

        let enc: ParameterEncoding = JSONEncoding.default

        let requestDate = Date()

        session.request(
            address,
            method: .put,
            parameters: parameters,
            encoding: enc,
            headers: headers
        )
        .responseData { response in

            let endDate = Date()
            let requestTime = endDate.timeIntervalSince1970 - requestDate.timeIntervalSince1970
            let requestPerformance = AdaptRequestTime(requestTime)

            self.logRequest(
                type: "PUT",
                requestDate: requestDate,
                endDate: endDate,
                requestTime: requestTime,
                requestPerformance: requestPerformance,
                address: address,
                headers: headers,
                parameters: parameters,
                response: response,
                statusCode: response.response?.statusCode ?? -1
            )

            switch response.result {
            case let .success(value):
                let dataJSON = JSON(value)
                completion(dataJSON, nil, response.response?.statusCode)

            case let .failure(error):
                completion(nil, error, response.response?.statusCode)
            }
        }
    }

    func patch(
        address: String,
        parameters: [String: Any] = [:],
        headers: Alamofire.HTTPHeaders = ["Content-Type": "application/json"],
//        profile: Profile? = nil,
        session: Session = AF,
        legacyCall: Bool = true,
        completion: ((JSON?, Error?, Int?) -> Void)? = nil
    ) {
//        var headers = headers
//        headers["User-Agent"] = userAgentAdditionalHeader
//
//        if let token = profile?.token {
//            if legacyCall {
//                headers["token"] = "\(token)"
//            }
//            headers["Authorization"] = "Bearer \(token)"
//
//            if token.count < 1 {
//                Log("\n\n!!! TOKEN IS EMPTY (LENGTH < 1) !!!\n\n")
//            }
//        }

        let requestDate = Date()

        let enc: ParameterEncoding = JSONEncoding.default
        session.request(
            address,
            method: .patch,
            parameters: parameters,
            encoding: enc,
            headers: headers
        )
        .responseData { response in

            let endDate = Date()
            let requestTime = endDate.timeIntervalSince1970 - requestDate.timeIntervalSince1970
            let requestPerformance = AdaptRequestTime(requestTime)

            self.logRequest(
                type: "PATCH",
                requestDate: requestDate,
                endDate: endDate,
                requestTime: requestTime,
                requestPerformance: requestPerformance,
                address: address,
                headers: headers,
                parameters: parameters,
                response: response,
                statusCode: response.response?.statusCode ?? -1
            )

            switch response.result {
            case let .success(value):
                let dataJSON = JSON(value)
                completion?(
                    dataJSON,
                    NSError.errorFrom(json: dataJSON),
                    response.response?.statusCode
                )

            case let .failure(error):
                completion?(nil, error, response.response?.statusCode)
            }
        }
    }

    func post(
        address: String,
        shouldHandleErrors: Bool = true,
        parameters: [String: Any] = [:],
        headers: Alamofire.HTTPHeaders = ["Content-Type": "application/json"],
        sendJSON: Bool = true,
//        profile: Profile? = nil,
        shouldRefreshToken: Bool = true,
        session: Session = AF,
        legacyCall: Bool = true,
        mockResponseKey: String? = nil,
        timeoutInterval: TimeInterval = 60,
        dataTransformer: DataTransformer? = nil,
        completion: ((JSON?, Error?, Int?) -> Void)?
    ) {
        var headers = headers
//        headers["User-Agent"] = userAgentAdditionalHeader

        var enc: ParameterEncoding = JSONEncoding.default

        if !sendJSON {
            enc = URLEncoding.default
            headers = ["Content-type": "application/x-www-form-urlencoded"]
        }

//        if let token = profile?.token {
//            if legacyCall {
//                headers["token"] = "\(token)"
//            }
//            headers["Authorization"] = "Bearer \(token)"
//
//            if token.count < 1 {
//                Log("\n\n!!! TOKEN IS EMPTY (LENGTH < 1) !!!\n\n")
//            }
//        }

        if let mockResponseKey = mockResponseKey,
           UserDefaults.standard.bool(forKey: mockResponseKey)
        {
            let filename = address
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: ":", with: "_")
                .replacingOccurrences(of: ".", with: "_")
                + "_mock_response.json"
            if let json = JSON.from(filename: filename) {
                completion?(json, nil, 200)
            }
        }

        let requestDate = Date()

        session.request(
            address,
            method: .post,
            parameters: parameters,
            encoding: enc,
            headers: headers
        )
            { $0.timeoutInterval = timeoutInterval }
            .responseData { response in

                let endDate = Date()
                let requestTime = endDate.timeIntervalSince1970 - requestDate.timeIntervalSince1970
                let requestPerformance = AdaptRequestTime(requestTime)

                self.logRequest(
                    type: "POST",
                    requestDate: requestDate,
                    endDate: endDate,
                    requestTime: requestTime,
                    requestPerformance: requestPerformance,
                    address: address,
                    headers: headers,
                    parameters: parameters,
                    response: response,
                    statusCode: response.response?.statusCode ?? -1
                )

                switch response.result {
                case let .success(value):
                    var dataJSON = JSON(value)
                    if let dataTransformer = dataTransformer,
                       let transformedData = dataTransformer.transform(data: value)
                    {
                        dataJSON = JSON(transformedData)
                    }
                    let statusCode = response.response?.statusCode
//                    if statusCode == 403 || statusCode == 401, shouldHandleErrors, shouldRefreshToken, let profile = profile {
//                        self.refreshTokenOrDie(
//                            tries: Self.refreshTokenRetries,
//                            profile: profile,
//                            lastError: nil
//                        ) { error, profile in
//                            if let error = error {
//                                completion?(nil, error, response.response?.statusCode)
//                                SendAuthorizationExpiredEvent(token: profile.backendInfo?.accessToken ?? "NONE")
//                            }
//                            else {
//                                self.post(
//                                    address: address,
//                                    shouldHandleErrors: shouldHandleErrors,
//                                    parameters: parameters,
//                                    headers: headers,
//                                    sendJSON: sendJSON,
//                                    profile: profile,
//                                    shouldRefreshToken: false,
//                                    session: session,
//                                    completion: completion
//                                )
//                            }
//                        }
//                    }
                    if response.response?.statusCode != 200, response.response?.statusCode != 201, shouldHandleErrors {
                        completion?(
                            nil,
                            NSError.errorFrom(json: dataJSON, defaultStatusCode: response.response?.statusCode ?? -1),
                            response.response?.statusCode
                        )
                    }
                    else {
                        completion?(dataJSON, nil, response.response?.statusCode)
                    }

                case let .failure(error):
                    debugPrint("Request Error: \(String(describing: error)); address: \(address)")

                    completion?(nil, error, response.response?.statusCode)
                }
            }
    }

    func delete(
        address: String,
//        profile: Profile? = nil,
        session: Session = AF,
        headers: Alamofire.HTTPHeaders = ["Content-Type": "application/json"],
        completion: ((JSON?, Error?, Int?) -> Void)? = nil
    ) {
//        var headers = headers
//        headers["User-Agent"] = userAgentAdditionalHeader
//
//        if let token = profile?.token {
//            headers["token"] = "\(token)"
//            headers["Authorization"] = "Bearer \(token)"
//
//            if token.count < 1 {
//                Log("\n\n!!! TOKEN IS EMPTY (LENGTH < 1) !!!\n\n")
//            }
//        }

        let requestDate = Date()

        session.request(
            address,
            method: .delete,
            headers: headers
        ).responseData { response in

            let endDate = Date()
            let requestTime = endDate.timeIntervalSince1970 - requestDate.timeIntervalSince1970
            let requestPerformance = AdaptRequestTime(requestTime)

            self.logRequest(
                type: "DELETE",
                requestDate: requestDate,
                endDate: endDate,
                requestTime: requestTime,
                requestPerformance: requestPerformance,
                address: address,
                headers: headers,
                parameters: [:],
                response: response,
                statusCode: response.response?.statusCode ?? -1
            )

            switch response.result {
            case let .success(value):
                let dataJSON = JSON(value)
                completion?(dataJSON, NSError.errorFrom(json: dataJSON), response.response?.statusCode)

            case let .failure(error):
                completion?(nil, error, response.response?.statusCode)
            }
        }
    }
}

extension Network: RequestDataSource {
    func requestServerAddress(_: Any) -> String {
        return Network.PROD
    }
}
