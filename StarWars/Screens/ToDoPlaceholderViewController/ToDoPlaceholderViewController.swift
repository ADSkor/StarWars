//
//  ToDoPlaceholderViewController.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Foundation
import UIKit

class ToDoPlaceholderViewController: UIViewController {
    @IBOutlet private weak var headerView: NavigationView?
    @IBOutlet private weak var label: UILabel?
    @IBOutlet private weak var safeAreaView: UIView?

    private var titleText = ""
    private var text = ""
    private var backButtonIsHidden = false

    static func fromStoryboard(
        titleText: String,
        text: String,
        backButtonIsHidden: Bool = false
    ) -> ToDoPlaceholderViewController {
        let viewController: ToDoPlaceholderViewController = .fromStoryboard()
        viewController.titleText = titleText
        viewController.text = text
        viewController.backButtonIsHidden = backButtonIsHidden
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        safeAreaView?.backgroundColor = UIColor(rgb: 0x373782)
        headerView?.set(title: titleText.uppercased())
        headerView?.delegate = self
        headerView?.set(backButtonIsHidden: backButtonIsHidden)
        label?.text = text.uppercased()
        label?.font = .systemFont(ofSize: 16)
    }
}

extension ToDoPlaceholderViewController: NavigationViewDelegate {
    func navigationViewDidTapBack(_: NavigationView) {
        popBack()
    }
}
