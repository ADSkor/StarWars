//
//  Context.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 01.11.2022.
//

import Foundation
import Miji

class Context: ObservableObject {
    private let delegates = MulticastDelegate<ContextDelegate>()
    private weak var performerDelegate: PerformerDelegate?

    lazy var api: API = SemiAPI(context: self)

    var user = User(json: "")

    private let bag = Bag()
    
    init(
        user: User = User(json: ""),
        performerDelegate: PerformerDelegate?
    ) {
        self.user = user
        self.performerDelegate = performerDelegate
    }

    func initialize() {
        user.initialize()
        debugPrint("We can init here anything what must be initiated in context...")
    }

    func subscribe(delegate: ContextDelegate) {
        delegates.subscribe(delegate)
    }

    func unsubscribe(delegate: ContextDelegate) {
        delegates.unsubscribe(delegate)
    }

    func addToUserSearching(text: String, completion: ((Error?) -> Void)?) {
        user.addToUserSearchHistory(text: text) { error in
            completion?(error)
        }
        delegates.notify { delegate in
            delegate.context(self, didUpdateUser: user)
        }
    }

    func applyLogoutCleanup() {
        delegates.notify { delegate in
            delegate.context(self, didUpdateUser: user)
        }
    }

    func saveProfile() {
        user.save()
        KeychainStorage.standard.remove(key: user.databaseKey)
        guard let stringJSON = Utils().toJSONString(object: user.searchStory) else {
            debugPrint("Error 'saveProfile()'")
            return
        }
        try? KeychainStorage.standard.set(key: user.databaseKey, value: stringJSON)
        debugPrint("User saved")
    }

    func removePersistentData() {
        KeychainStorage.standard.remove(key: "savedCookies")
    }
}
