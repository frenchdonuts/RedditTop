//
//  Listing.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

struct Listing: Codable {
    var after: String?
    var before: String?
    var children: [Children]
}
