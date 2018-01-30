//
//  ListPager.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

struct Cursors {
    var after: String?
    var before: String?
}

class Paginator<T> {
    typealias completionHandler = ([T], Cursors?, Error?) -> Void
    var requestInProcess = false
    var items : [T] = []
    var cursors : Cursors? = nil
    var updateRequest: ((_ startingAt: String?, _ completion: completionHandler) -> Void)?
    var updatedNotification: ((_ numberOfNewItems: Int) -> Void)?
    var moreAvailable: Bool {
        return cursors == nil || cursors?.after != nil
    }

    var isEmpty: Bool {
        guard !requestInProcess, items.count == 0, !moreAvailable else {
            return false
        }
        return true
    }

    func reset() {
        guard self.requestInProcess else { return }
        self.requestInProcess = true

        if let request = self.updateRequest {
            request(nil) { [weak self]
                (newItems, newCursors, error) -> Void in
                guard error == nil else { return }
                if let strongSelf = self {
                    strongSelf.requestInProcess = false
                    strongSelf.cursors = newCursors
                    strongSelf.items = newItems
                    strongSelf.updatedNotification?(newItems.count)
                }
            }
        }
    }

    func fetchItems(startingAt startIndex: Int = 0) {
        guard moreAvailable else { return }
        guard !requestInProcess else { return }
        requestInProcess = true

        if let request = self.updateRequest {
            request(cursors?.after) {  [weak self]
                (newItems, newCursors, error) -> Void in
                if let strongSelf = self {
                    strongSelf.requestInProcess = false
                    guard error == nil else { return }
                    if newCursors?.before == strongSelf.cursors?.after {
                        strongSelf.cursors = newCursors
                        strongSelf.items.append(contentsOf: newItems)
                        strongSelf.updatedNotification?(newItems.count)
                    } else {
                        strongSelf.cursors = newCursors
                        strongSelf.items = newItems
                        strongSelf.updatedNotification?(newItems.count)
                    }
                }
            }
        }
    }
}
