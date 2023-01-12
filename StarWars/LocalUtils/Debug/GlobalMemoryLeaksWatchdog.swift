//
//  GlobalMemoryLeaksWatchdog.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 01.01.2023.
//

import Foundation

let GlobalMemoryLeaksWatchdog: MemoryLeaksWatchdog = .init()

class MemoryLeaksWatchdog {
    #if DEBUG
        private var weakObjects: NSHashTable<NSObject> = .weakObjects()
        private var timer: Timer?

        func restartWatching() {
            timer = Timer.scheduledTimer(
                withTimeInterval: 30,
                repeats: false, // do not repeat, otherwise it will flood debug print
                block: { [weak self] _ in
                    let enumerator = self?.weakObjects.objectEnumerator()
                    while let object = enumerator?.nextObject() {
                        debugPrint("🔎 MemoryLeaksWatchdog \(object) is still alive")
                    }
                    self?.restartWatching()
                }
            )
        }

        func watch(object: NSObject) {
            debugPrint("🐶 MemoryLeaksWatchdog watching object: \(object)")
            weakObjects.add(object)
        }
    #endif
}
