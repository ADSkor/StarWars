//
//  UIActivityIndicatorView.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import UIKit

public extension UIActivityIndicatorView {
    func start(color: UIColor = .systemBlue) {
        startAnimating()
        isHidden = false
        self.color = color
    }

    func stop() {
        stopAnimating()
        isHidden = true
    }
}
