//
//  AnyEpic.swift
//  CombineRedux
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import Combine

/// A type erasurer to the Epics. Use it to make a reference for a Epic.
public struct AnyEpic<StateType>: UntypedActionEpic {
    let recoveredActionFor: (AnyPublisher<Action, Never>,
                                    @escaping StateGetter<StateType>,
                                    @escaping StateGetter<StateType>) -> [AnyPublisher<Action, Never>]
    
    init<EpicType: UntypedActionEpic>(epic: EpicType) where StateType == EpicType.StateType {
        recoveredActionFor = epic.untypedActionsPublishersFor
    }
    
    public func untypedActionsPublishersFor(actionPublisher publisher: AnyPublisher<Action, Never>,
                   appStateGetter: @escaping StateGetter<StateType>,
                   oldAppStateGetter: @escaping StateGetter<StateType>) -> [AnyPublisher<Action, Never>] {
        return recoveredActionFor(publisher, appStateGetter, oldAppStateGetter)
    }
}
