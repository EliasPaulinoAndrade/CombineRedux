//
//  ReducerMock.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
@testable import CombineRedux

class ReducerMock<StateType>: Reducer {
    typealias ActionType = TestAction
    
    var wasCalled: Bool = false
    var shouldReturn: StateType?
    
    init(shouldReturn: StateType? = nil) {
        self.shouldReturn = shouldReturn
    }
    
    func reduce(state: StateType, withTypedAction action: TestAction) -> ReducedState<StateType> {
        self.wasCalled = true
        
        if let shouldReturn = shouldReturn {
            return .changed(state: shouldReturn)
        }
        return .notChanged
    }
}
