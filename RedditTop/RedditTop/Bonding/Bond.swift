//
//  Bond.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/30/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

protocol Bondable {
    associatedtype BondType
    var designatedBond: Bond<BondType>? { get }
}

protocol Dynamical {
    associatedtype DynamicType
    func designatedDynamic() -> Dynamic<DynamicType>
}

class Bond<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var bondedDynamics: [Dynamic<T>] = []

    init(_ listener: @escaping Listener) {
        self.listener = listener
    }

    func bind(_ dynamic: Dynamic<T>, fire: Bool = true) {
        dynamic.bonds.append(BondStorage(self))
        bondedDynamics.append(dynamic)
        if fire {
            listener?(dynamic.value)
        }
    }

    func unbindAll() {
        for dynamic in bondedDynamics {
            var bondsToKeep: [BondStorage<T>] = []
            for bondStorage in dynamic.bonds {
                if let bond = bondStorage.bond {
                    if bond !== self {
                        bondsToKeep.append(bondStorage)
                    }
                }
            }
            dynamic.bonds = bondsToKeep
        }
        bondedDynamics.removeAll(keepingCapacity: true)
    }
}

class BondStorage<T> {
    weak var bond: Bond<T>?
    init(_ bond: Bond<T>) {
        self.bond = bond
    }
}

class Dynamic<T> {
    var value: T {
        didSet {
            for bondStorage in bonds {
                bondStorage.bond?.listener?(value)
            }
        }
    }

    var bonds: [BondStorage<T>] = []

    init(_ value: T) {
        self.value = value
    }
}

precedencegroup LeftAssociativePrecedence {
    associativity: left
}

infix operator >>> : LeftAssociativePrecedence

func >>> <T>(left: Dynamic<T>, right: Bond<T>) {
    right.bind(left)
}

func >>> <T>(left: Dynamic<T>, right: @escaping (T) -> Void) -> Bond<T> {
    let bond = Bond<T>(right)
    bond.bind(left)
    return bond
}

func >>> <T: Dynamical, U>(left: T, right: Bond<U>) where T.DynamicType == U {
    left.designatedDynamic() >>> right
}

func >>> <T: Dynamical, U: Bondable>(left: T, right: U)  where T.DynamicType == U.BondType {
    guard let designatedBond = right.designatedBond else { return }
    left.designatedDynamic() >>> designatedBond
}

func >>> <T, U: Bondable>(left: Dynamic<T>, right: U) where U.BondType == T {
    guard let designatedBond = right.designatedBond else { return }
    left >>> designatedBond
}
