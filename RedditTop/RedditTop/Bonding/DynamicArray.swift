//
//  Array+Bond.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/30/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

class ArrayBond<T>: Bond<Array<T>> {
    var insertListener: (([Int]) -> Void)?
    var removeListener: (([Int], [T]) -> Void)?
    var updateListener: (([Int]) -> Void)?
}
