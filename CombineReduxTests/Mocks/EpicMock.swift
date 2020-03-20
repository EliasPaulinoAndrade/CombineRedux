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
    var shouldReturn: ActionType?
    var lastState: StateType?
    var lastOldState: StateType?
    
    init(shouldReturn: ActionType? = nil) {
        self.shouldReturn = shouldReturn
    }
    
    func actionPublisherFor(actionsPublisher: AnyPublisher<ActionType, Never>,
                              appStateGetter: @escaping () -> StateType,
                              oldAppStateGetter: @escaping () -> StateType) -> AnyPublisher<ActionType, Never> {
        
        let shouldReturn = self.shouldReturn
        
        return actionsPublisher.flatMap { [weak self] action -> AnyPublisher<ActionType, Never> in
            self?.actionsWasCalled = true
            self?.lastState = appStateGetter()
            self?.lastOldState = oldAppStateGetter()
            
            if let shouldReturn = shouldReturn {
                 return Just<ActionType>(shouldReturn).eraseToAnyPublisher()
            } else {
                return Empty().eraseToAnyPublisher()
            }            
        }.eraseToAnyPublisher()
    }
}
