//
//  StoreTests.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import XCTest
import Combine
import Nimble

@testable import CombineRedux

class StoreTests: XCTestCase {
    func test_dispatchAction_callsAllEpics() {
        let epic1 = EpicMock<TestAction, String>()
        let epic2 = EpicMock<TestAction, String>()
        let sut = Store(state: "state", reducer: ReducerMock(), epics: epic1.asAnyEpic, epic2.asAnyEpic)
        
        expect(epic1.lastAction).to(beNil())
        expect(epic2.lastAction).to(beNil())
        
        sut.dispatch(action: TestAction.state1)
        
        expect(epic1.lastAction).to(equal(.state1))
        expect(epic2.lastAction).to(equal(.state1))
    }
    
    func test_epicResult_generatesNewActions() {
        let epic1 = EpicMock<TestAction, String>(shouldReturn: .state2, waitAction: .state1)
        let epic2 = EpicMock<TestAction, String>(waitAction: .state2)
        let sut = Store(state: "state", reducer: ReducerMock(), epics: epic1.asAnyEpic, epic2.asAnyEpic)
        
        sut.dispatch(action: TestAction.state1)
        
        expect(epic1.lastAction).toEventually(equal(.state1))
        expect(epic2.lastAction).toEventually(equal(.state2))
    }
    
    func test_dispatchAction_callsReducer() {
        let reducer = ReducerMock<String>()
        let sut = Store(state: "state", reducer: reducer, epics: [])
        
        sut.dispatch(action: TestAction.state1)
        
        expect(reducer.wasCalled).toEventually(equal(true))
    }

    func test_reducerResult_changesState() {
        let reducer = ReducerMock(shouldReturn: "changedState")
        let sut = Store(state: "state", reducer: reducer, epics: [])
        
        sut.dispatch(action: TestAction.state1)
        
        expect(sut.getOldState()).toEventually(equal("state"))
        expect(sut.getState()).toEventually(equal("changedState"))
    }
    
    func test_observeStore_isEqualToObserveState() {
        let reducer = ReducerMock(shouldReturn: "changedState")
        let sut = Store(state: "state", reducer: reducer, epics: [])
        let waiter = CombineWaiter.wait(publisher: sut.eraseToAnyPublisher())
        
        sut.dispatch(action: TestAction.state1)
        
        expect(waiter.results).toEventually(equal(["state", "changedState"]))
    }
    
    func test_mapIfChangedReceivesSubscription_itIsOnlyCalledWhenThereAreChangedAtSubstate() {
        let reducer = ReducerMock<MockState>(shouldReturn: .init(subState: MockSubState(attributte: "changed"), attributte: 5))
        let sut = Store(state: .init(), reducer: reducer, epics: [])
        
        let waiter = CombineWaiter.wait(publisher: sut.mapIfChanged(keyPath: \.subState))
        
        sut.dispatch(action: TestAction.state1)
        sut.dispatch(action: TestAction.state1)
        
        expect(waiter.results).toEventually(equal([MockSubState(attributte: "changed")]))
    }
}
