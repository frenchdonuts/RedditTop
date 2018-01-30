//
//  RedditAPIClient.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

class RedditAPIClient {
    static var basePath = "https://reddit.com"
    static let queue = OperationQueue()
    static let configuration = URLSessionConfiguration.default
    static var session = URLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
}
