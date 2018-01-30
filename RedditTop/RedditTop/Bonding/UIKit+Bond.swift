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
        self.helper.listener =  { [unowned self] in
            self.value = $0
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
            let b = Bond<Bool>() { [unowned self] v in
                DispatchQueue.main.async {
                    if v {
                        self.beginRefreshing()
                    } else {
                        self.endRefreshing()
                    }
                }
            }
            objc_setAssociatedObject(self, &designatedBondHandleUIRefreshControl, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}

private var designatedBondHandleUILabel: UInt8 = 0

extension UILabel: Bondable {
    var designatedBond: Bond<String>? {
        if let b = objc_getAssociatedObject(self, &designatedBondHandleUILabel) as? Bond<String> {
            return b
        } else {
            let b = Bond<String>() { [unowned self] v in self.text = v }
            objc_setAssociatedObject(self, &designatedBondHandleUILabel, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}

var associatedObjectHandleUIImageView: UInt8 = 0;

extension UIImageView: Bondable {
    var designatedBond: Bond<UIImage?>? {
        if let b = objc_getAssociatedObject(self, &associatedObjectHandleUIImageView) as? Bond<UIImage?> {
            return b
        } else {
            let b = Bond<UIImage?>() { [unowned self] v in self.image = v }
            objc_setAssociatedObject(self, &associatedObjectHandleUIImageView, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}

@objc class TableViewDynamicArrayDataSource: NSObject, UITableViewDataSource {
    var dynamic: DynamicArray<UITableViewCell>

    init(dynamic: DynamicArray<UITableViewCell>) {
        self.dynamic = dynamic
        super.init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dynamic.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.dynamic[indexPath.item]
    }
}

class TableViewBond<T>: ArrayBond<UITableViewCell> {
    weak var tableView: UITableView?
    var dataSource: TableViewDynamicArrayDataSource?

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()

        insertions = { i in
            self.tableView?.beginUpdates()
            self.tableView?.insertRows(at: i.map { IndexPath(row: $0, section: 0) },with: .automatic)
            self.tableView?.endUpdates()
        }

        deletions = { i, o in
            self.tableView?.beginUpdates()
            self.tableView?.deleteRows(at: i.map { IndexPath(row: $0, section: 0) },with: .automatic)
            self.tableView?.endUpdates()
        }

        updates = { i in
            self.tableView?.beginUpdates()
            self.tableView?.reloadRows(at: i.map { IndexPath(row: $0, section: 0) },with: .automatic)
            self.tableView?.endUpdates()
        }
    }

    override func bind(_ dynamic: Dynamic<Array<UITableViewCell>>, fire: Bool) {
        super.bind(dynamic, fire: false)
        if let dynamic = dynamic as? DynamicArray {
            dataSource = TableViewDynamicArrayDataSource(dynamic: dynamic)
            tableView?.dataSource = dataSource
            tableView?.reloadData()
        }
    }
}

private var designatedBondHandleUITableView: UInt8 = 0

extension UITableView: Bondable {
    var designatedBond: Bond<Array<UITableViewCell>>? {
        if let b = objc_getAssociatedObject(self, &designatedBondHandleUITableView) as? Bond<Array<UITableViewCell>> {
            return b
        } else {
            let b = TableViewBond<UITableViewCell>(tableView: self)
            objc_setAssociatedObject(self, &designatedBondHandleUITableView, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}

