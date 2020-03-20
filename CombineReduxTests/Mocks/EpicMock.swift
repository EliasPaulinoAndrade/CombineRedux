//
//  EpicMock.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import Combine
@testable import CombineRedux

class EpicMock<ActionType: Action, StateType>: SimpleEpic {
    var actionsWasCalled = false
    var shouldReturn: ActionType
    
    init(shouldReturn: ActionType) {
        self.shouldReturn = shouldReturn
    }
    
    func actionPublisherFor(actionsPublisher: AnyPublisher<ActionType, Never>,
                              appStateGetter: @escaping () -> StateType,
                              oldAppStateGetter: @escaping () -> StateType) -> AnyPublisher<ActionType, Never> {
        
        let shouldReturn = self.shouldReturn
        
        return actionsPublisher.flatMap { [weak self] action -> AnyPublisher<ActionType, Never> in
            self?.actionsWasCalled = true
            return Just<ActionType>(shouldReturn).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
