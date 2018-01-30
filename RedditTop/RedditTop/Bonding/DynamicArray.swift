//
//  DynamicArray.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/30/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

class ArrayBond<T>: Bond<Array<T>> {
    var insertions: (([Int]) -> Void)?
    var deletions: (([Int], [T]) -> Void)?
    var updates: (([Int]) -> Void)?

    init(_ insertions: (([Int]) -> Void)? = nil, _ deletions: (([Int], [T]) -> Void)? = nil, _ updates: (([Int]) -> Void)? = nil) {
        self.insertions = insertions
        self.deletions = deletions
        self.updates = updates
        super.init()
    }

    override func bind(_ dynamic: Dynamic<Array<T>>, fire: Bool = false) {
        super.bind(dynamic, fire: fire)
    }
}

class DynamicArray<T>: Dynamic<Array<T>> {

    var count: Int {
        return value.count
    }

    override init(_ v: Array<T>) {
        super.init(v)
    }

    func append(array: Array<T>) {
        if array.count > 0 {
            let count = value.count
            value += array
            dispatchInsertion(Array(count..<value.count))
        }
    }

    subscript(index: Int) -> T {
        get {
            return value[index]
        }
        set(newObject) {
            value[index] = newObject
            if index == value.count {
                dispatchInsertion([index])
            } else {
                dispatchUpdate([index])
            }
        }
    }

    private func dispatchInsertion(_ indices: [Int]) {
        for bondStorage in bonds {
            if let arrayBond = bondStorage.bond as? ArrayBond {
                arrayBond.insertions?(indices)
            }
        }
    }

    private func dispatchRemoval(_ indices: [Int], objects: [T]) {
        for bondStorage in bonds {
            if let arrayBond = bondStorage.bond as? ArrayBond {
                arrayBond.deletions?(indices, objects)
            }
        }
    }

    private func dispatchUpdate(_ indices: [Int]) {
        for bondStorage in bonds {
            if let arrayBond = bondStorage.bond as? ArrayBond {
                arrayBond.updates?(indices)
            }
        }
    }
}
