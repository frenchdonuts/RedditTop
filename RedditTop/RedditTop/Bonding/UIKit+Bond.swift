//
//  UIRefreshControl+Bond.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/30/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

protocol ControlDynamicHelper {
    associatedtype T
    var value: T { get }
    var listener: ((T) -> Void)? { get set }
}

class ControlDynamic<T, U: ControlDynamicHelper> : Dynamic<T> where U.T == T {
    var helper: U
    init(helper: U) {
        self.helper = helper
        super.init(helper.value)
        self.helper.listener =  { [weak self] in
            self?.value = $0
        }
    }
}

class RefreshControlDynamicHelper: NSObject, ControlDynamicHelper {
    var listener: ((Bool) -> Void)?
    weak var refreshControl: UIRefreshControl?
    var value: Bool {
        return refreshControl?.isRefreshing ?? false
    }

    init(_ refreshControl: UIRefreshControl) {
        self.refreshControl = refreshControl
        super.init()
        refreshControl.addTarget(self, action: #selector(RefreshControlDynamicHelper.valueChanged), for: .valueChanged)
    }

    @objc func valueChanged() {
        guard let refreshControl = self.refreshControl else { return }
        listener?(refreshControl.isRefreshing)
    }

    deinit {
        refreshControl?.removeTarget(self, action: nil, for: .valueChanged)
    }
}

private var designatedBondHandleUIRefreshControl: UInt8 = 0

extension UIRefreshControl: Dynamical, Bondable {
    func valueDynamic() -> Dynamic<Bool> {
        return ControlDynamic<Bool, RefreshControlDynamicHelper>(helper: RefreshControlDynamicHelper(self))
    }

    func designatedDynamic() -> Dynamic<Bool> {
        return valueDynamic()
    }

    var designatedBond: Bond<Bool>? {
        if let b = objc_getAssociatedObject(self, &designatedBondHandleUIRefreshControl) as? Bond<Bool> {
            return b
        } else {
            let b = Bond<Bool>() { [weak self] v in
                DispatchQueue.main.async {
                    if v {
                        self?.beginRefreshing()
                    } else {
                        self?.endRefreshing()
                    }
                }
            }
            objc_setAssociatedObject(self, &designatedBondHandleUIRefreshControl, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}

