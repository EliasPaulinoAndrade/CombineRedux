//
//  Buildable.swift
//  Demos
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

protocol Buildable {
    func with<ValueType>(_ attributte: WritableKeyPath<Self, ValueType>, equalTo value: ValueType) -> Self
}

extension Buildable {
    func with<ValueType>(_ attributte: WritableKeyPath<Self, ValueType>, equalTo value: ValueType) -> Self {
        var selfCopy = self
        selfCopy[keyPath: attributte] = value
        return selfCopy
    }
}
