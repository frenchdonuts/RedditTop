//
//  ImageCache.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

private let minimumCapacity = 500

class Cache<K: Hashable,V> {
    private var cacheDict: [K: V] = Dictionary<K,V>(minimumCapacity: minimumCapacity)

    func value(for key: K) -> V? {
        return cacheDict[key]
    }

    func set(value: V, for key: K) {
        cacheDict[key] = value
    }

    func remove(for key: K) {
        cacheDict[key] = nil
    }

    func flush() {
        cacheDict.removeAll()
    }

    subscript(key: K) -> V? {
        get {
            return value(for: key)
        }
        set {
            if let newValue = newValue {
                set(value: newValue, for: key)
            } else {
                remove(for: key)
            }
        }
    }
}
