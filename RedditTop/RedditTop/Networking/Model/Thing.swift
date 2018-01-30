//
//  Thing.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

class Thing {
    enum ThingKind: String {
        case unknown = "unknown"
        case listing = "Listing"
        case link = "t3"
    }
    var id:  String
    var name: String
    var kind: ThingKind
    var data: Object?

    init(id: String, name: String, kind: ThingKind, data: Object) {
        self.id = id
        self.name = name
        self.kind = kind
        self.data = data
    }

    init(json: [String: Any]) {
        id = json["id"] as? String ?? ""
        name = json["name"] as? String ?? ""
        kind = ThingKind(rawValue: json["kind"] as? String ?? "unknown") ?? .unknown
        if let dataJson = json["data"] as? [String: Any] {
            data = object(of: kind, with: dataJson)
        }
    }

    func object(of kind: ThingKind, with json: [String: Any]) -> Object? {
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
