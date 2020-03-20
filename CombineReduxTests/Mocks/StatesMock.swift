//
//  StatesMock.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

struct MockSubState: Equatable {
    let attributte: String
}

struct MockState: Equatable {
    let subState: MockSubState
    let attributte: Int
    
    init() {
        subState = .init(attributte: "")
        attributte = 0
    }
    
    init(subState: MockSubState, attributte: Int) {
        self.subState = subState
        self.attributte = attributte
    }
}
