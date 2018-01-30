//
//  UIRefreshControl+Bond.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/30/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

private var bondHandle = "bondHandle"
private var dynamicStateHandle = "dynamicStateHandle"

extension UIRefreshControl {
    var refreshingBond: Bond<Bool> {
        if let b = objc_getAssociatedObject(self, &bondHandle) as? Bond<Bool> {
            return b
        } else {
            let b = Bond<Bool>() { [unowned self] v in
                DispatchQueue.main.async {
                    if v {
                        self.beginRefreshing()
                    } else {
                        self.endRefreshing()
                    }
                }
            }
            objc_setAssociatedObject(self, &bondHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}

extension UIRefreshControl: Bondable {
    typealias BondType = Bool
    var designatedBond: Bond<Bool> {
        return refreshingBond
    }
}
