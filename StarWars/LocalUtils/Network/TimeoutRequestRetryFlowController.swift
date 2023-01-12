//
//  TimeoutRequestRetryFlowController.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 01.01.2023.
//

import Alamofire
import Miji
import SwiftyJSON
import UIKit

class TimeoutRequestRetryFlowController {
    static func performGetIfCan(
        address: String,
        headers: Alamofire.HTTPHeaders,
        shouldHandleErrors: Bool,
        shouldRefreshToken: Bool,
        session: Session = AF,
        completion: ((JSON?, Error?, Int?) -> Void)?
    ) {
        Log("💩💩💩 Can't load request with address: \(address)\nAsking user if they wants to repeat")
        guard let viewController = KeyWindow?.rootViewController?.visibleViewController else {
            Self.performTimeoutResult(completion: completion)
            return
        }
        viewController.prompt(
            title: "Не получилось загрузить данные, еще раз?",
            yesBlock: {
                Network.shared.get(
                    address: address,
                    headers: headers,
                    shouldHandleErrors: shouldHandleErrors,
                    shouldHandleTimeout: true,
                    shouldRefreshToken: shouldRefreshToken,
                    session: session,
                    completion: completion
                )
            },
            noBlock: {
                Self.performTimeoutResult(completion: completion)
            }
        )
    }

    static func performTimeoutResult(completion: ((JSON?, Error?, Int?) -> Void)?) {
        completion?(
            nil,
            NSError.error(
                code: NSURLErrorTimedOut,
                localizedDescription: "Превышено ожидание ответа от сервера, попробуйте позже"
            ),
            NSURLErrorTimedOut
        )
    }
}
