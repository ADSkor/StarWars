//
//  CustomViewController.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 01.11.2022.
//

import Foundation
import Miji
import UIKit

class CustomViewController: UIViewController {
    let bag: Bag = .init()

    private var isGestureBackEnabled: Bool {
        navigationController?.viewControllers.at(0) != self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("⚡ ViewController viewDidLoad: \(Self.self)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("💡 ViewController viewDidAppear: \(Self.self)")

        navigationController?.interactivePopGestureRecognizer?.isEnabled = isGestureBackEnabled
        navigationController?.interactivePopGestureRecognizer?.delegate = isGestureBackEnabled ? self : nil
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("❌ ViewController viewDidDisappear: \(Self.self)")
        bag.clean()
    }

    func send<T>(
        _ payloadClass: T.Type,
        name: GlobalNotifications,
        payload: T
    ) {
        main {
            Shingo(payloadClass).send(
                name: name.rawValue,
                payload: payload
            )
        }
    }

    func receive<T>(
        _ payloadClass: T.Type,
        name: GlobalNotifications,
        completion: ((T) -> Void)?
    ) {
        main { [bag] in
            Shingo(payloadClass).receive(
                name: name.rawValue,
                bag: bag
            ) { payload in
                completion?(payload)
            }
        }
    }
}

extension CustomViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
            return isGestureBackEnabled
        }
        return true
    }
}
