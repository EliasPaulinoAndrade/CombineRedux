//
//  ReducerMock.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
@testable import CombineRedux

class ReducerMock: Reducer {
    typealias ActionType = TestAction
    typealias StateType = Int
    
    var reduceWasCalled: Bool = false
    let shouldReturn: ReducedState<Int>
    
    init(shouldReturn: ReducedState<Int> = .notChanged) {
        self.shouldReturn = shouldReturn
    }
    
    func reduce(state: Int, withTypedAction action: TestAction) -> ReducedState<Int> {
        self.reduceWasCalled = true
        
        return shouldReturn
    }
}
