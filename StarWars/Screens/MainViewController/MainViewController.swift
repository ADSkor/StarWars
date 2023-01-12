//
//  MainViewController.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 04.01.2023.
//

import UIKit
import Miji


class MainViewController: CustomTabBarController {
    @PersistentGlobalVariable(UserDefaultsKeys.APP_OPENED_COUNT.rawValue, 0)
    private var appOpenedCount

    private var searchScreenNavigationController: UINavigationController?
    private var anotherScreenNavigationController: UINavigationController?
    
    private var openSearchScreenObserver: NSObjectProtocol?

    private var searchScreenIndex: Int? {
        guard let searchScreenViewController = searchScreenNavigationController else { return 0 }
        return viewControllers?.firstIndex(of: searchScreenViewController) ?? 0
    }

    private var anotherScreenIndex: Int? {
        guard let anotherScreenNavigationController else { return 0 }
        return viewControllers?.firstIndex(of: anotherScreenNavigationController) ?? 0
    }

    private var context: Context?
    private weak var dataSource: MainViewControllerDataSource?
    
    static func fromStoryboard(
        context: Context,
        dataSource: MainViewControllerDataSource?
    ) -> MainViewController {
        let viewController: MainViewController = .fromStoryboard()
        viewController.context = context
        viewController.dataSource = dataSource
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        tabBar.backgroundColor = UIColor(rgb: 0xEAF0EB)
        tabBar.tintColor = .purpleSW
        tabBarItem.title = ""
        tabBar.backgroundImage = UIImage(named: "gray")?.imageResized(to: CGSize(width: 48, height: 48))

        setTabBarItems()

        appOpenedCount += 1
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    func switchToSearchScreenTab() {
        guard let searchScreenIndex else { return }
        selectedIndex = searchScreenIndex
    }

    func popAllInnerScreens() {
        (selectedViewController as? UINavigationController)?
            .setNavigationBarHidden(
                true, animated: false
            )
        (selectedViewController as? UINavigationController)?.popToRootViewController(animated: true)
    }

    private func setTabBarItems() {
        guard let context else { return }
        let viewControllers = NSMutableArray(array: self.viewControllers ?? [])

        let searchScreenViewController = SearchScreenViewController.fromStoryboard(
            context: context,
            searchText: ""
        )
        searchScreenNavigationController = UINavigationController()
        searchScreenNavigationController?.isNavigationBarHidden = true
        searchScreenNavigationController?.viewControllers = [searchScreenViewController]
        viewControllers.add(searchScreenNavigationController as Any)
        

        let anotherViewController = ToDoPlaceholderViewController.fromStoryboard(
            titleText: "Additional VC",
            text: "Something new is coming up here soon...",
            backButtonIsHidden: true
        )

        anotherScreenNavigationController = UINavigationController()
        anotherScreenNavigationController?.isNavigationBarHidden = true
        anotherScreenNavigationController?.viewControllers = [anotherViewController]
        anotherViewController.loadViewIfNeeded()
        viewControllers.add(anotherScreenNavigationController as Any)

        self.viewControllers = viewControllers as? [UIViewController]

        tabBar.unselectedItemTintColor = .black

        guard let searchScreenIndex else { return }
        let searchScreen = tabBar.items?.at(searchScreenIndex)
        searchScreen?.image = UIImage(named: "astronaut")?.imageResized(to: CGSizeMake(24, 24))
        searchScreen?.selectedImage = UIImage(named: "astronaut")?.imageResized(to: CGSizeMake(32, 32))
        searchScreen?.title = "SW Search"

        guard let anotherScreenIndex else { return }
        let anotherScreen = tabBar.items?.at(anotherScreenIndex)
        anotherScreen?.image = UIImage(named: "darthVader")?.imageResized(to: CGSizeMake(24, 24))
        anotherScreen?.selectedImage = UIImage(named: "darthVader")?.imageResized(to: CGSizeMake(32, 32))
        anotherScreen?.title = "DartV Screen"
    }

    func openSearchScreen() {
        selectedIndex = searchScreenIndex ?? 0
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func prepareForOpenCatalogue() {
        openSearchScreenObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name("openSearchScreen"), object: nil, queue: nil) { [weak self] _ in
            self?.openSearchScreen()
            self?.dismiss(animated: true, completion: nil)
        }
    }
}


extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldBeRequiredToFailBy _: UIGestureRecognizer) -> Bool {
        return true
    }
}
