//
//  ImageCache.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

protocol Cache {
    associatedtype CachableValue
    associatedtype CachableKey
    func value(for key: CachableKey) -> CachableValue?
    func set(value: CachableValue, for key: CachableKey)
    func flush()
    subscript(key: CachableKey) -> CachableValue? { get set }
}
