//
//  EpicGroupTests.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import XCTest
import Combine
import Nimble

@testable import CombineRedux

class EpicGroupTests: XCTestCase {
    func test_sendInputToEpicGroup_producesInputIntoTheGroupedEpics() {
        let epic1 = EpicMock<TestAction, MockSubState>()
        let epic2 = EpicMock<TestAction, MockSubState>()
        
        let sut = [epic1, epic2].epicGroup(keyPath: \MockState.subState)
        let inputSubject = PassthroughSubject<Action, Never>()

        let actionPublishers = sut.untypedActionsPublishersFor(actionPublisher: inputSubject.eraseToAnyPublisher(),
                                                               appStateGetter: { return MockState() },
                                                               oldAppStateGetter: { return MockState() })
        
        expect(actionPublishers.count).to(equal(2))
        CombineWaiter.wait(publisher: actionPublishers[0])
        CombineWaiter.wait(publisher: actionPublishers[1])
        
        inputSubject.send(TestAction.state1)
        
        expect(epic1.actionsWasCalled).toEventually(equal(true))
        expect(epic2.actionsWasCalled).toEventually(equal(true))
    }
    
    func test_outputIsSentByGroupedEpics_producesCorrectOutputIntoEpicsGroup() {
        let epic1 = EpicMock<TestAction, MockSubState>(shouldReturn: .state1)
        let epic2 = EpicMock<TestAction, MockSubState>(shouldReturn: .state2)
        
        let sut = EpicGroup(subEpics: epic1, epic2, keyPath: \MockState.subState)
        let inputSubject = PassthroughSubject<Action, Never>()
        let actionPublishers = sut.untypedActionsPublishersFor(actionPublisher: inputSubject.eraseToAnyPublisher(),
                                                               appStateGetter: { return MockState() },
                                                               oldAppStateGetter: { return MockState() })
        let firstPublisherWaiter = CombineWaiter.wait(publisher: actionPublishers[0])
        let secondPublisherWaiter = CombineWaiter.wait(publisher: actionPublishers[1])
        
        inputSubject.send(TestAction.state1)
        
        expect(firstPublisherWaiter.results.count).to(equal(1))
        expect(secondPublisherWaiter.results.count).to(equal(1))
        expect(firstPublisherWaiter.results[0] as? TestAction).to(equal(.state1))
        expect(secondPublisherWaiter.results[0] as? TestAction).to(equal(.state2))
    }
    
}

struct MockSubState { }

struct MockState {
    let subState: MockSubState
    
    init() {
        self.subState = .init()
    }
}
