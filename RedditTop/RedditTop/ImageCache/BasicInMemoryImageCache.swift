//
//  InMemoryImageCache.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

class BasicInMemoryImageCache: ImageCache {
    private var cacheDict: [URL: UIImage] = [:]

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
}
