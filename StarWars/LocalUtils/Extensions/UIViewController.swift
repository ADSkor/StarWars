//
//  UIViewController.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 01.01.2023.
//

import Miji
import UIKit

extension UIViewController: AppearanceEventsViewController {
    public func viewWillPop() {
        #if DEBUG
            GlobalMemoryLeaksWatchdog.watch(object: self)
        #endif

        if let navigationController = self as? UINavigationController {
            navigationController.viewControllers.forEach { $0.viewWillPop() }
        }
        else if let tabBarController = self as? UITabBarController {
            tabBarController.viewControllers?.forEach { $0.viewWillPop() }
        }
        else if let presentedViewController = presentedViewController {
            return presentedViewController.viewWillPop()
        }
    }

    func setupToHideKeyboardOnTapOnView() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        }
        else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        }
        else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        }
        else {
            return self
        }
    }
}
