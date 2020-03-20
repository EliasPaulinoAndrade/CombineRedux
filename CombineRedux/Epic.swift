//
//  Epic.swift
//  CombineRedux
//
//  Created by Elias Paulino on 19/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import Combine

/*
 A Epic is a type that react actions and can generate new actions. Usually, a epic waits until a action happen, then it processes some stuff and return a new action.
 **/

/// A protocol for Epics with no especific type for the Actions. Use it when you Epic depends on multiple types os Action.
protocol UntypedActionEpic {
    associatedtype StateType
    
    func untypedActionsPublishersFor(actionPublisher: AnyPublisher<Action, Never>,
                                     appStateGetter: @escaping StateGetter<StateType>,
                                     oldAppStateGetter: @escaping StateGetter<StateType>) -> [AnyPublisher<Action, Never>]
}

/// A Epic with associatedtype for the Action Type. Use it when your Epic depends on only one Action implmentation.
protocol Epic: UntypedActionEpic {
    associatedtype ActionType: Action
    
    func actionsPublishersFor(actionsPublisher: AnyPublisher<ActionType, Never>,
                              appStateGetter: @escaping StateGetter<StateType>,
                              oldAppStateGetter: @escaping StateGetter<StateType>) -> [AnyPublisher<ActionType, Never>]
}

/// A Epic thar abbreviates the Epic method assignature for returning only one Action Publisher. Use it when you need publish only one new action at the and of the epic processing.
protocol SimpleEpic: Epic {
    func actionPublisherFor(actionsPublisher: AnyPublisher<ActionType, Never>,
                            appStateGetter: @escaping StateGetter<StateType>,
                            oldAppStateGetter: @escaping StateGetter<StateType>) -> AnyPublisher<ActionType, Never>
}

extension Epic {
    /// A default implementation for untypedActionsFor method. It delegates all the calls to this methods to the actionsFor method, for doing it, it is necessary make a casting from Action protocol usage to the associatedtype ActionType, so the actionsFor is only called when the casting is possible.
    func untypedActionsPublishersFor(actionPublisher: AnyPublisher<Action, Never>,
                                     appStateGetter: @escaping StateGetter<StateType>,
                                     oldAppStateGetter: @escaping StateGetter<StateType>) -> [AnyPublisher<Action, Never>] {
        return actionsPublishersFor(
            actionsPublisher: actionPublisher.compactMap { action -> ActionType? in
                return action as? ActionType
            }.eraseToAnyPublisher(),
            appStateGetter: appStateGetter,
            oldAppStateGetter: oldAppStateGetter
        ).compactMap { actionPublisher -> AnyPublisher<Action, Never>? in
            return actionPublisher.map { $0 }.eraseToAnyPublisher()
        }
    }
}

extension SimpleEpic {
    /// a default implementation to the actionsFor.
    func actionsPublishersFor(actionsPublisher: AnyPublisher<ActionType, Never>,
                              appStateGetter: @escaping StateGetter<StateType>,
                              oldAppStateGetter: @escaping StateGetter<StateType>) -> [AnyPublisher<ActionType, Never>] {
        return [actionPublisherFor(actionsPublisher: actionsPublisher, appStateGetter: appStateGetter, oldAppStateGetter: oldAppStateGetter)]
    }
}
