//
//  Reducer.swift
//  CombineRedux
//
//  Created by Elias Paulino on 19/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

/// A Reducer with no especific type to the Action. Use it when your Reducer depends on multiple action types.
protocol UntypedActionReducer {
    associatedtype StateType
    func reduce(state: StateType, withAction action: Action) -> ReducedState<StateType>
}

/// A Reducer with associatedtype to the Action, Use it when you depend on a especific type of Action.
protocol Reducer: UntypedActionReducer {
    associatedtype ActionType: Action
    
    func reduce(state: StateType, withTypedAction action: ActionType) -> ReducedState<StateType>
}

extension Reducer {
    /// default implementation to reduce method. It casts the action to the especific Action type.
    func reduce(state: StateType, withAction action: Action) -> ReducedState<StateType> {
        guard let castedAction = action as? ActionType else { return .notChanged }
        return reduce(state: state, withTypedAction: castedAction)
    }
}

/// Represents a state change
enum ReducedState<StateType> {
    case changed(state: StateType), notChanged
}
