//
//  GHReducer.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import CombineRedux
import Combine

struct GHReducer: UntypedActionReducer {
    typealias StateType = GHState
    
    func reduce(state: GHState, withAction action: Action) -> ReducedState<GHState> {
        if case let .changed(peopleState) = PeopleReducer().reduce(state: state.peopleState, withAction: action) {
            return .changed(state: state.with(\.peopleState, equalTo: peopleState))
        }
        return .notChanged
    }
}
