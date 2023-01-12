//
//  User.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 02.11.2022.
//

import Foundation
import SwiftyJSON
import Miji


class User {
    var databaseKey = "1" //ToDo: Update with new users
    private var delegates = MulticastDelegate<UserDelegate>()
    var searchStory: [String] = []

    func initialize() {
        loadSearchStory()
    }
    
    init(json: JSON) {
        databaseKey = json["databaseKey"].stringValue
        searchStory = json["user\(databaseKey)SearchHistory"].arrayValue.map { $0.stringValue }
    }
    
    func addToUserSearchHistory(text: String, completion: ((Error?) -> Void)?) {
        Add(object: [text], as: "user\(databaseKey)SearchHistory") { error in
            completion?(error)
        }
    }
    
    func loadSearchStory() {
        guard let json = Utils().loadJSON(key: "user\(databaseKey)SearchHistory") else { return }
        searchStory = json.arrayValue.map { $0.stringValue }
    }
    
    func saveUserPassword(password: String) {
        try? KeychainStorage.standard.set(key: "\(databaseKey)Password", value: password)
    }
    
    func passwordFromStorage() -> String? {
        try? KeychainStorage.standard.get(key: "\(databaseKey)Password")
    }
    
    func save() {
        Save(object: self, as: databaseKey)
    }
    
    func deleteCurrentUser() {
        Utils().remove(key: databaseKey)
        Utils().remove(key: "user\(databaseKey)SearchHistory")
    }

    func subscribe(delegate: UserDelegate) {
        delegates.subscribe(delegate)
    }

    func unsubscribe(delegate: UserDelegate) {
        delegates.unsubscribe(delegate)
    }
}
