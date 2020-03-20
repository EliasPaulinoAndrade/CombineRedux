//
//  EpicTests.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 19/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import XCTest
import Combine
import Nimble
@testable import CombineRedux

class EpicTests: XCTestCase {
    
    //untyped default implementation tests
    func test_sendActionToInputPublisherWithTypeDifferentOfTypedEpic_dontProducesOutputAndTheTypedEpicMethodIsNotCalled() {
        let sut = EpicMock<TestAction, Int>(shouldReturn: .state1)
        let inputPublisher = PassthroughSubject<Action, Never>()
        let actionPublishers = sut.untypedActionsPublishersFor(actionPublisher: inputPublisher.eraseToAnyPublisher(),
                                                        appStateGetter: { return 0 },
                                                        oldAppStateGetter: { return 0 })
        let waiter = CombineWaiter.wait(publisher: actionPublishers.first!)

        inputPublisher.send(TestAction2())
        expect(waiter.results.count).toEventually(equal(0))
        expect(sut.actionsWasCalled).to(equal(false))
    }
    
    func test_sendActionToInputPublisherWithSameTypeOfTypedEpic_producesOutputAndEpicMethodIsCalled() {
        let sut = EpicMock<TestAction, Int>(shouldReturn: .state1)
        let inputPublisher = PassthroughSubject<Action, Never>()
        let actionPublishers = sut.untypedActionsPublishersFor(actionPublisher: inputPublisher.eraseToAnyPublisher(),
                                                        appStateGetter: { return 0 },
                                                        oldAppStateGetter: { return 0 })
        let waiter = CombineWaiter.wait(publisher: actionPublishers.first!)
        inputPublisher.send(TestAction.state1)
        expect(waiter.results.count).toEventually(equal(1))
        expect(sut.actionsWasCalled).to(equal(true))
    }
    
    func test_outputSentByTypedEpicWhen_producesTheSameOutputToUntypedMethod() {
        let sut = EpicMock<TestAction, Int>(shouldReturn: .state2)
        let inputPublisher = PassthroughSubject<Action, Never>()
        let actionPublishers = sut.untypedActionsPublishersFor(actionPublisher: inputPublisher.eraseToAnyPublisher(),
                                                        appStateGetter: { return 0 },
                                                        oldAppStateGetter: { return 0 })
        
        let waiter = CombineWaiter.wait(publisher: actionPublishers.first!)
        inputPublisher.send(TestAction.state1)
        expect(waiter.results.count).to(equal(1))
        expect(waiter.results[0]).to(beAKindOf(TestAction.self))
        expect(waiter.results[0] as? TestAction).to(equal(.state2))
    }
    
    func test_inputSentByUntypedEpic_producesInputToTheTypedEpicWithCorrectState() {
        let sut = EpicMock<TestAction, Int>(shouldReturn: .state1)
        let inputPublisher = PassthroughSubject<Action, Never>()
        
        var appState: (current: Int, old: Int) = (0, 0)
        
        let actionPublishers = sut.untypedActionsPublishersFor(actionPublisher: inputPublisher.eraseToAnyPublisher(),
                                                        appStateGetter: { return appState.current },
                                                        oldAppStateGetter: { return appState.old })
        CombineWaiter.wait(publisher: actionPublishers.first!)
        appState.current = 1
        
        inputPublisher.send(TestAction.state1)
        
        expect(sut.lastState).to(equal(1))
        expect(sut.lastOldState).to(equal(0))
    }
    
    //simple epic default implementation
    func test_sendActionToEpicMethod_producesActionToSimpleEpicMethod() {
        let sut = EpicMock<TestAction, Int>(shouldReturn: .state1)
        let inputPublisher = PassthroughSubject<TestAction, Never>()
        let actionPublishers = sut.actionsPublishersFor(actionsPublisher: inputPublisher.eraseToAnyPublisher(),
                                                       appStateGetter: { return 0 },
                                                       oldAppStateGetter: { return 0 })
        
        CombineWaiter.wait(publisher: actionPublishers.first!)
        inputPublisher.send(.state1)
        expect(sut.actionsWasCalled).to(equal(true))
    }
    
    func test_outputSentBySimpleEpic_producesSingleOutputToEpic() {
        let sut = EpicMock<TestAction, Int>(shouldReturn: .state2)
        let inputPublisher = PassthroughSubject<TestAction, Never>()
        let actionPublishers = sut.actionsPublishersFor(actionsPublisher: inputPublisher.eraseToAnyPublisher(),
                                                       appStateGetter: { return 0 },
                                                       oldAppStateGetter: { return 0 })
        
        expect(actionPublishers.count).to(equal(1))
        let waiter = CombineWaiter.wait(publisher: actionPublishers.first!)
        inputPublisher.send(.state2)
        inputPublisher.send(.state2)
        
        expect(waiter.results).to(equal([.state2, .state2]))
    }
}
