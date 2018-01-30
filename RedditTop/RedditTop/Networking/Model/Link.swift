//
//  Link.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

class Link: Object, Votable, Created {
    var created: Double = 0
    var createdUtc: Double = 0
    var ups: Int = 0
    var downs: Int = 0
    var likes: Bool?
    var author: String = ""
    var title: String = ""
    var selftextHtml: String = ""
    var numComments: Int = 0
    var thumbnail: String = ""
    var score: Int = 0

    init(json: [String: Any]) {
        created = json["created"] as? Double ?? 0
        createdUtc = json["created"] as? Double ?? 0
        ups = json["ups"] as? Int ?? 0
        downs = json["downs"] as? Int ?? 0
        likes = json["likes"] as? Bool ?? false
        author = json["author"] as? String ?? ""
        title = json["title"] as? String ?? ""
        selftextHtml = json["selftextHtml"] as? String ?? ""
        selftextHtml = json["selftextHtml"] as? String ?? ""
        numComments = json["numComments"] as? Int ?? 0
        thumbnail = json["thumbnail"] as? String ?? ""
        score = json["score"] as? Int ?? 0
    }
}
