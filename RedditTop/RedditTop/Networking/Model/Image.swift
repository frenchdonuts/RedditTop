//
//  Image.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/31/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

struct Image: Codable {
    var source: ImageInfo
    var resolutions: [ImageInfo]
}
