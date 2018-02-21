//
//  ImageCache.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 2/20/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

class ImageCache: Cache<URL, UIImage> {
    private var memorySize: Int = 0
    static let memoryLimit: Int = 100 * 1024 * 1024 //100 MBytes
    private var queue: LinkedList<URL> = LinkedList<URL>()
    private var nodes: [URL: LinkedList<URL>.LinkedListNode<URL>] = [:]

    override func set(value: UIImage, for key: URL) {
        super.set(value: value, for: key)
        queue.insert(key, at: 0)
        nodes[key] = queue.first
        memorySize += value.memorySize
        while memorySize >= ImageCache.memoryLimit {
            guard let lastValue = queue.last?.value else { break }
            remove(for: lastValue)
        }
    }

    override func value(for key: URL) -> UIImage? {
        guard let value = super.value(for: key) else { return nil }
        guard let node = nodes[key] else { return value }
        queue.remove(node: node)
        queue.insert(node, at: 0)
        nodes[key] = queue.first
        return value
    }

    override func remove(for key: URL) {
        if let value = value(for: key) {
            memorySize -= value.memorySize
        }
        if let node = nodes[key] {
            queue.remove(node: node)
            nodes[key] = nil
        }
        super.remove(for: key)
    }

    override func flush() {
        super.flush()
        nodes.removeAll()
        queue.removeAll()
        memorySize = 0
    }
}
