//
//  CombineReduxTests.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 19/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import XCTest
@testable import CombineRedux

class ReducerTests: XCTestCase {
    func test_callTypedReducerWithActionOfOtherType_theTypedReducerMethodIsNotCalledAndReturnsNotChanged() {
        let sut = ReducerMock()
        let newState = sut.reduce(state: 0, withAction: TestAction2())
        if case .notChanged = newState {
            XCTAssert(true)
        } else {
            XCTFail()
        }
        
        XCTAssertEqual(sut.reduceWasCalled, false)
    }
    
    func test_callTypedReducerWithActionOfSmaeTyoe_theTypedReducerMethodIsCalled() {
        let sut = ReducerMock()
        let _ = sut.reduce(state: 0, withAction: TestAction())
        XCTAssertEqual(sut.reduceWasCalled, true)
    }
    
    func test_typedReducerReturnChanged_theUnTypedMethodReturnsChanged() {
        let sut = ReducerMock(shouldReturn: .changed(state: 1))
        let reducedState = sut.reduce(state: 0, withAction: TestAction())
        
        if case let .changed(newState) = reducedState, newState == 1 {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }
    
    func test_typedReducerReturnNotChanged_theUnTypedMethodReturnsNotChanged() {
        let sut = ReducerMock(shouldReturn: .notChanged)
        let reducedState = sut.reduce(state: 0, withAction: TestAction())
        
        if case .notChanged = reducedState {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }
}
