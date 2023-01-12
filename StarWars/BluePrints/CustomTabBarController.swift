//
//  CustomTabBarController.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 04.01.2023.
//

import Foundation
import UIKit
import Miji

class CustomTabBarController: UITabBarController {
    let bag: Bag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("⚡ TabBarController viewDidLoad: \(Self.self)")
        Log("⚡ TabBarController viewDidLoad: \(Self.self)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("📖 TabBarController viewDidAppear: \(Self.self)")
        Log("📖 TabBarController viewDidAppear: \(Self.self)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("❌ TabBarController viewDidDisappear: \(Self.self)")
        Log("❌ TabBarController viewDidDisappear: \(Self.self)")
        bag.clean()
    }

    func receive<T>(
        _ payloadClass: T.Type,
        name: GlobalNotifications,
        completion: ((T) -> Void)?
    ) {
        Shingo(payloadClass).receive(
            name: name.rawValue,
            bag: bag
        ) { payload in
            completion?(payload)
        }
    }

    func send<T>(
        _ payloadClass: T.Type,
        name: GlobalNotifications,
        payload: T
    ) {
        Shingo(payloadClass).send(
            name: name.rawValue,
            payload: payload
        )
    }
}

extension CustomTabBarController: DebuggableViewController {
    func debugNotification(
        debugInfo: String
    ) {
        Log(debugInfo)
    }

    func promptYesBlockSelected(
        yesText: String,
        title: String,
        message: String
    ) {
        Log("--- 👤👌 PROMPT YES BLOCK SELECTED BY USER \"\(yesText)\" for title: \"\(title)\" and message: \"\(message)\" ---")
    }

    func promptNoBlockSelected(
        noText: String,
        title: String,
        message: String
    ) {
        Log("--- 👤🛑 PROMPT NO BLOCK SELECTED BY USER \"\(noText)\" for title: \"\(title)\" and message: \"\(message)\" ---")
    }
}
