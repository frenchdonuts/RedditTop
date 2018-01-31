//
//  Votable.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

protocol Votable {
    var ups: Int { get set }
    var downs: Int { get set }
    var likes: Bool? { get set }
}

