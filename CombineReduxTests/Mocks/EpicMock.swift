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

class EpicMock<ActionType: Action, StateType>: SimpleEpic where ActionType: Equatable {
    var actionsWasCalled = false
    var shouldReturn: ActionType?
    var waitAction: ActionType?
    var lastState: StateType?
    var lastOldState: StateType?
    var lastAction: ActionType?
    
    init(shouldReturn: ActionType? = nil, waitAction: ActionType? = nil) {
        self.shouldReturn = shouldReturn
        self.waitAction = waitAction
    }
    
    func actionPublisherFor(actionsPublisher: AnyPublisher<ActionType, Never>,
                              appStateGetter: @escaping () -> StateType,
                              oldAppStateGetter: @escaping () -> StateType) -> AnyPublisher<ActionType, Never> {
        let shouldReturn = self.shouldReturn
        let waitAction = self.waitAction
        
        return actionsPublisher.flatMap { [weak self] action -> AnyPublisher<ActionType, Never> in
            
            guard (waitAction != nil && waitAction! == action) || waitAction == nil else {
                return Empty().eraseToAnyPublisher()
            }
            
            self?.actionsWasCalled = true
            self?.lastState = appStateGetter()
            self?.lastOldState = oldAppStateGetter()
            self?.lastAction = action
            
            if let shouldReturn = shouldReturn {
                 return Just<ActionType>(shouldReturn).eraseToAnyPublisher()
            } else {
                return Empty().eraseToAnyPublisher()
            }            
        }.eraseToAnyPublisher()
    }
}
