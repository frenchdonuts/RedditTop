//
//  Link.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

struct Link: Codable {
    var created: Double
    var author: String
    var title: String
    var numComments: Int
    var thumbnail: String
    var url: String
    var preview: Preview?

    enum CodingKeys: String, CodingKey {
        case created
        case author
        case title
        case numComments = "num_comments"
        case thumbnail
        case url
        case preview
    }

    var imageURL: URL? {
        guard let str = preview?.images.first?.source.url else { return nil }
        return URL(string: str)
    }

    init(created: Double, author: String, title: String, numComments: Int, thumbnail: String, url: String,  preview: Preview?) {
        self.created = created
        self.author = author
        self.title = title
        self.numComments = numComments
        self.thumbnail = thumbnail
        self.url = url
        self.preview = preview
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        preview = try values.decodeIfPresent(Preview.self, forKey: .preview)
        created = try values.decode(Double.self, forKey: .created)
        author = try values.decode(String.self, forKey: .author)
        title = try values.decode(String.self, forKey: .title)
        numComments = try values.decode(Int.self, forKey: .numComments)
        thumbnail = try values.decode(String.self, forKey: .thumbnail)
        url = try values.decode(String.self, forKey: .url)
    }
}
