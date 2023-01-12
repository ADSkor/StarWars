//
//  ApplicationInitializeViewController.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 01.11.2022.
//

import UIKit
import Miji
import SDWebImage

class ApplicationInitializeViewController: CustomViewController {
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet private weak var loadingTextLabel: UILabel?

    private var context: Context?
    private var sendPopToRootViewControllerObserver: Any?
    private weak var mainViewController: MainViewController?
    
    private let preloaderTexts = [
        "Downloading...",
    ]

    @IBAction private func didTap(button _: UIButton?) {
        #if DEBUG
        debugPrint("We can use it for debug session...")
        #endif
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
            GlobalMemoryLeaksWatchdog.restartWatching()
        #endif
        activityIndicatorView?.start()

        sendPopToRootViewControllerObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name(
                rawValue: GlobalNotifications.popToRootViewControllerEvent.rawValue
            ),
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.popToRoot()
        }
        proceed()
    }

    private func proceed() {
        let context = Context(
            performerDelegate: self
        )
        self.context = context
        context.initialize()
        
        let viewController: MainViewController = .fromStoryboard(
            context: context,
            dataSource: self
        )
        mainViewController = viewController
        var viewControllers = navigationController?.viewControllers ?? []
        let animated = viewControllers.count > 1 ? false : true // replace without animation
        viewControllers = [self, viewController]
        navigationController?.setViewControllers(viewControllers, animated: animated)
    }

    private func dismissAll() {
        popTo(self, animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension ApplicationInitializeViewController: PerformerDelegate {
    func popAllInnerScreens() {
        mainViewController?.popAllInnerScreens()
    }
    
    func popToRoot() {
        guard let mainViewController else { return }
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.dismiss(animated: true, completion: nil)

        popTo(
            mainViewController,
            animated: true
        )
    }
}

extension ApplicationInitializeViewController: MainViewControllerDataSource {
    var performerDelegate: PerformerDelegate? {
        return self
    }
}
