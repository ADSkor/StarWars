//
//  NavigationView.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import UIKit
import Miji

class NavigationView: XibView {
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var backView: UIView?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint?

    weak var delegate: NavigationViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        backView?.backgroundColor = .purpleSW
    }

    @IBAction private func backButtonDidTap(button _: UIButton?) {
        Log("◀ ◀ ◀ User Did Tap Back - NavigationView backButtonDidTap")
        delegate?.navigationViewDidTapBack(self)
    }

    func applyAlternateStyle() {
        backButton?.set(image: UIImage(named: "backArrowBlack"))
        titleLabel?.font = .systemFont(ofSize: 16)
        titleLabel?.textColor = .darkText
        backView?.backgroundColor = .white
    }

    func set(
        title: String,
        textColor: UIColor = .white,
        textFont: UIFont = .boldItalicFont(size: 16)
    ) {
        titleLabel?.text = title
        titleLabel?.font = textFont
        titleLabel?.textColor = textColor
    }

    func set(backButtonIsHidden: Bool) {
        backButton?.isHidden = backButtonIsHidden
//        leadingConstraint?.constant = backButtonIsHidden ? -56 : 0
    }

    func set(textAlign: NSTextAlignment) {
        titleLabel?.textAlignment = textAlign
    }

    func set(backgroundColor: UIColor?, backButtonImage: UIImage?) {
        backView?.backgroundColor = backgroundColor
        backButton?.setImage(backButtonImage, for: .normal)
    }
}
