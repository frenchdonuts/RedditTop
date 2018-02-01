//
//  URL+FileExtensions.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/31/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

extension URL {
    var isLinkToImage: Bool {
        return ["jpg", "png", "gif"].contains(self.lastPathComponent)
    }
}
