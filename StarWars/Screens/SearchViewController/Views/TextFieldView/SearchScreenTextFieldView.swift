//
//  SearchScreenTextFieldView.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Miji
import UIKit

class SearchScreenTextFieldView: XibView {
    @IBOutlet private weak var separatorView: UIView?

    weak var delegate: SearchScreenTextFieldViewDelegate?

    @IBOutlet private weak var searchButton: UIButton?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var textField: UITextField?

    override func awakeFromNib() {
        super.awakeFromNib()
        searchButton?.tintColor = UIColor.white
        backButton?.tintColor = .black
        textField?.font = UIFont.boldItalicFont(size: 16)
        textField?.returnKeyType = .search
        textField?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        textField?.delegate = self
        separatorView?.backgroundColor = .systemGray2
    }

    func resignFocus() {
        textField?.resignFirstResponder()
    }

    func setFocus() {
        textField?.becomeFirstResponder()
    }

    func set(text: String) {
        textField?.text = text
    }
    
    func set(backButtonIsHidden: Bool) {
        backButton?.isHidden = backButtonIsHidden
    }
    

    @IBAction private func didTap(backButton _: UIButton?) {
        delegate?.searchScreenTextFieldViewDidTapBackButton(self)
    }

    @IBAction private func didTap(searchButton _: UIButton?) {
        delegate?.searchScreenTextFieldViewDidTapSearchButton(self, text: textField?.text ?? "")
    }

    @objc private func textDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        delegate?.searchScreenTextFieldViewTextDidChange(self, text: text)
    }
}

extension SearchScreenTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_: UITextField) {
        delegate?.searchScreenTextFieldViewDidBeginEditing(self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchScreenTextFieldViewDidTapSearchButton(self, text: textField.text ?? "")
        return true
    }
}
