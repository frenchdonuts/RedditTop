//
//  Listing.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

class Listing: Object {
    var after: String?
    var before: String?
    var count: Int = 0
    var children: [Thing] = []

    init(json: [String: Any]) {
        after = json["after"] as? String
        before = json["before"] as? String
        count = json["count"] as? Int ?? 0
        let childrenDict = json["children"] as? [[String: Any]] ?? []
        for childrenJson in childrenDict {
            children.append(Thing(json: childrenJson))
        }
    }
}
