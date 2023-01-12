//
//  String.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation
import SwiftyJSON
import UIKit

extension String {
    func asPixlImageURL(forImageWithSize size: CGSize, quality: Int) -> URL? {
        let width = Int(size.width)
        let height = width
        let imageUrlString = "\(self)?quality=\(quality)&f=\(width)x\(height)"
        let url = URL(string: imageUrlString)
        return url
    }
    
    func asInt() -> Int? {
        return Int(self)
    }
    
    func asIntOrZero() -> Int {
        return Int(self) ?? 0
    }

    func isValidUrl() -> Bool {
        guard let url = asURL() else {
            return false
        }
        return UIApplication.shared.canOpenURL(url as URL)
    }
    
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[A-Za-z._+-])(?=.*[0-9]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let isValidPassword = passwordTest.evaluate(with: self)
        
        return isValidPassword
    }

    var isValidPhoneNumber: Bool {
        let phoneNumberRegex = "^[7-8]\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        
        return isValidPhone
    }

    var isValidEmail: Bool {
        let eMailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", eMailRegex)
        let isValidEmail = emailTest.evaluate(with: self)

        return isValidEmail
    }

    func isValid(by regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: self)
        return result
    }

    func toLocalDate(separator: String = "-", outputSeparator: String = ".") -> String {
        let splitted = split(separator)
        guard let day = splitted.at(2),
              let month = splitted.at(1),
              let year = splitted.at(0)
        else {
            return ""
        }
        let output = "\(day)\(outputSeparator)\(month)\(outputSeparator)\(year)"
        return output
    }

    func toServerDate(separator: String = ".", outputSeparator: String = "-") -> String {
        let splitted = split(separator)
        guard let day = splitted.at(0),
              let month = splitted.at(1),
              let year = splitted.at(2)
        else {
            return ""
        }
        let output = "\(year)\(outputSeparator)\(month)\(outputSeparator)\(day)"
        return output
    }

    func replace(_ lhs: String, _ rhs: String) -> String {
        return replacingOccurrences(of: lhs, with: rhs)
    }

    func asError() -> Error {
        return NSError.error(localizedDescription: self)
    }
}
