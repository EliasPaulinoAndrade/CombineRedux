//
//  AnyEpicTests.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import Combine
import XCTest
import Nimble
@testable import CombineRedux

class AnyEpicTests: XCTestCase {
    func test_sendInputToAnyEpicMethod_producesInputToTheErasedEpic() {
        let epic = EpicMock<TestAction, Int>()
        let sut = AnyEpic(epic: epic)
        let inputPublisher = PassthroughSubject<Action, Never>()
        let actionPublishers = sut.untypedActionsPublishersFor(actionPublisher: inputPublisher.eraseToAnyPublisher(),
                                                               appStateGetter: { return 0 },
                                                               oldAppStateGetter: { return 0 })
        
        CombineWaiter.wait(publisher: actionPublishers.first!)
        inputPublisher.send(TestAction.state1)
        
        expect(epic.actionsWasCalled).to(equal(true))
    }
    
    func test_erasedEpicSendOutput_generatesCorrectOutputToAnyEpic() {
        let epic = EpicMock<TestAction, Int>(shouldReturn: .state2)
        let sut = AnyEpic(epic: epic)
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
}
