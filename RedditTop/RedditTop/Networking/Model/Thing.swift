//
//  Thing.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

class Thing {
    enum Kind: String {
        case unknown = "unknown"
        case listing = "Listing"
        case link = "t3"
    }
    var id:  String
    var name: String
    var kind: Kind
    var data: Object?

    init(json: [String: Any]) {
        id = json["id"] as? String ?? ""
        name = json["name"] as? String ?? ""
        kind = Kind(rawValue: json["kind"] as? String ?? "unknown") ?? .unknown
        if let dataJson = json["data"] as? [String: Any] {
            data = object(of: kind, with: dataJson)
        }
    }

    func object(of kind: Kind, with json: [String: Any]) -> Object? {
        switch kind {
        case .listing:
            return Listing(json: json)
        case .link:
            return Link(json: json)
        case .unknown:
            return nil
        }
    }
}
