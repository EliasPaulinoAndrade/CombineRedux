//
//  EpicGroup.swift
//  CombineRedux
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import Combine

/// A Epic that groups othet epics while continue acting as a normal epic.
public struct EpicGroup<SubEpicType: UntypedActionEpic, StateType, SubStateType>: UntypedActionEpic where SubEpicType.StateType == SubStateType {
    private let subEpics: [SubEpicType]
    private let keyPath: KeyPath<StateType, SubStateType>

    public init(subEpics: [SubEpicType], keyPath: KeyPath<StateType, SubStateType>) {
        self.subEpics = subEpics
        self.keyPath = keyPath
    }
    
    public init(subEpics: SubEpicType ..., keyPath: KeyPath<StateType, SubStateType>) {
        self.subEpics = subEpics
        self.keyPath = keyPath
    }
    
    public init(epic: SubEpicType, keyPath: KeyPath<StateType, SubStateType>) {
        self.init(subEpics: [epic], keyPath: keyPath)
    }
    
    public func untypedActionsPublishersFor(actionPublisher publisher: AnyPublisher<Action, Never>,
                                     appStateGetter: @escaping () -> StateType,
                                     oldAppStateGetter: @escaping () -> StateType) -> [AnyPublisher<Action, Never>] {
        return subEpics.flatMap { subMiddleware -> [AnyPublisher<Action, Never>] in
            return subMiddleware.untypedActionsPublishersFor(
                actionPublisher: publisher,
                appStateGetter: { return appStateGetter()[keyPath: self.keyPath] },
                oldAppStateGetter: { return oldAppStateGetter()[keyPath: self.keyPath] }
            )
        }
    }
}
