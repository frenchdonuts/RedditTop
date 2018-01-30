//
//  BasicInMemoryImageCache.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

class BasicInMemoryImageCache: ImageCache {
    private static let minimumCapacity = 500
    private var cacheDict: [URL: UIImage] = Dictionary(minimumCapacity: minimumCapacity)

    func image(for url: URL) ->UIImage? {
        return cacheDict[url]
    }

    func set(image: UIImage, for url: URL) {
        cacheDict[url] = image
    }

    subscript(url: URL) ->UIImage? {
        get {
            return cacheDict[url]
        }
        set {
            cacheDict[url] = newValue
        }
    }

    func flush() {
        cacheDict.removeAll()
    }
}
