//
//  Paginator.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

struct Cursors: Codable {
    var after: String?
    var before: String?

    init(after: String? = nil, before: String? = nil) {
        self.after = after
        self.before = before
    }
}

class Paginator<T: Codable> : Codable {
    typealias completionHandler = ([T], Cursors?, Error?) -> Void
    typealias updateHandler = (_ after: String? , _ completion: @escaping completionHandler) -> Void
    var requestInProcess = false
    var items : [T] = []
    var cursors : Cursors? = nil
    var updateRequest: updateHandler?
    var onUpdatedHandler: ((_ numberOfNewItems: Int) -> Void)?
    var moreAvailable: Bool {
        return cursors == nil || cursors?.after != nil
    }

    var isEmpty: Bool {
        guard !requestInProcess, items.isEmpty, !moreAvailable else {
            return false
        }
        return true
    }

    enum CodingKeys: String, CodingKey {
        case items
        case cursors
    }

    init() {
        
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cursors = try values.decode(Cursors.self, forKey: .cursors)
        items = try values.decode([T].self, forKey: .items)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cursors, forKey: .cursors)
        try container.encode(items, forKey: .items)
    }

    func reset() {
        guard !requestInProcess else { return }
        requestInProcess = true
        if let request = updateRequest {
            request(nil) { [weak self]
                (newItems, newCursors, error) -> Void in
                guard error == nil else { return }
                if let strongSelf = self {
                    strongSelf.requestInProcess = false
                    strongSelf.cursors = newCursors
                    strongSelf.items = newItems
                    strongSelf.onUpdatedHandler?(newItems.count)
                }
            }
        }
    }

    func fetchItems() {
        guard moreAvailable else { return }
        guard !requestInProcess else { return }
        requestInProcess = true

        if let request = updateRequest {
            request(cursors?.after) {  [weak self]
                (newItems, newCursors, error) -> Void in
                if let strongSelf = self {
                    strongSelf.requestInProcess = false
                    guard error == nil else { return }
                    if newCursors?.after != strongSelf.cursors?.after {
                        strongSelf.cursors = newCursors
                        strongSelf.items.append(contentsOf: newItems)
                    }
                    strongSelf.onUpdatedHandler?(newItems.count)
                }
            }
        }
    }
}
