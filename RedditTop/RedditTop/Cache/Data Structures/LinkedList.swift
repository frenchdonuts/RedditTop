//
//  LinkedList.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 2/20/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

public final class LinkedList<T> {
    public class LinkedListNode<T> {
        var value: T
        var next: LinkedListNode?
        weak var previous: LinkedListNode?

        public init(value: T) {
            self.value = value
        }
    }

    public typealias Node = LinkedListNode<T>

    fileprivate var head: Node?

    public init() {}

    public var first: Node? {
        return head
    }

    public var last: Node? {
        guard var node = head else {
            return nil
        }

        while let next = node.next {
            node = next
        }
        return node
    }

    public func node(at index: Int) -> Node? {
        guard let head = head else { return nil }
        if index == 0 {
            return head
        } else {
            var node = head.next
            for _ in 1..<index {
                node = node?.next
                if node == nil {
                    break
                }
            }
            return node
        }
    }

    public subscript(index: Int) -> T? {
        let node = self.node(at: index)
        return node?.value
    }

    public func insert(_ value: T, at index: Int) {
        let newNode = Node(value: value)
        self.insert(newNode, at: index)
    }

    public func insert(_ newNode: Node, at index: Int) {
        if index == 0 {
            newNode.next = head
            head?.previous = newNode
            head = newNode
        } else {
            let prev = node(at: index-1)
            let next = prev?.next
            newNode.previous = prev
            newNode.next = next
            next?.previous = newNode
            prev?.next = newNode
        }
    }

    public func removeAll() {
        head = nil
    }

    @discardableResult public func remove(node: Node) -> T {
        let prev = node.previous
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev
        node.previous = nil
        node.next = nil
        return node.value
    }

    @discardableResult public func remove(at index: Int) -> T? {
        guard let node = self.node(at: index) else { return nil }
        return remove(node: node)
    }
}
