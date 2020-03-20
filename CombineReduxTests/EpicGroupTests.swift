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
        
        CombineWaiter.wait(publisher: actionPublishers.first!)
        
        inputSubject.send(TestAction.state1)
        
        expect(epic1.actionsWasCalled).toEventually(equal(true))
        expect(epic2.actionsWasCalled).toEventually(equal(true))
    }
}

struct MockSubState { }

struct MockState {
    let subState: MockSubState
    
    init() {
        self.subState = .init()
    }
}
