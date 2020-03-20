//
//  StatesMock.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

struct MockSubState { }

struct MockState {
    let subState: MockSubState
    
    init() {
        subState = .init()
    }
}
