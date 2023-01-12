//
//  GlobalNotifications.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 01.11.2022.
//

import Foundation

enum GlobalNotifications: String {
    case openCatalogue
    case popToRootViewControllerEvent
    case applicationDidBecomeActive
    case applicationResignActive
}

private func Send(
    notification: GlobalNotifications,
    userInfo: [AnyHashable: Any]? = nil
) {
    NotificationCenter.default.post(
        Notification(
            name: Notification.Name(rawValue: notification.rawValue),
            userInfo: userInfo
        )
    )
}

private func Send(
    notification: GlobalNotifications,
    payload: Any
) {
    let userInfo = ["payload": payload]
    Send(
        notification: notification,
        userInfo: userInfo
    )
}

func SendPopToRootViewControllerEvent() {
    Send(notification: .popToRootViewControllerEvent)
}

func SendDidRequestOpenCatalogueEvent() {
    Send(notification: .openCatalogue)
}

func SendApplicationDidBecomeActiveEvent() {
    Send(
        notification: .applicationDidBecomeActive,
        payload: ApplicationBecomeActivePayload()
    )
}
class ApplicationBecomeActivePayload {}

func SendApplicationResignActive() {
    Send(
        notification: .applicationResignActive,
        payload: ApplicationResignActivePayload()
    )
}
class ApplicationResignActivePayload {}
