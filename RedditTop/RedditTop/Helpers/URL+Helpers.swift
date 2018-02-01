//
//  URL+Helpers.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/31/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

extension URL {
    var isImageUrl: Bool {
        return ["png", "jpg"].contains(self.pathExtension)
    }

}
