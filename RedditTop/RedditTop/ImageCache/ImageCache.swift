//
//  ImageCache.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

protocol ImageCache {
    func image(for url: URL) ->UIImage?
    func set(image: UIImage, for url: URL)
    func flush()
    subscript(url: URL) -> UIImage? { get set }
}
