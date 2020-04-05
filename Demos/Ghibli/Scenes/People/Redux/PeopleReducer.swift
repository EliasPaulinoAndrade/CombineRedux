//
//  PeopleReducer.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import CombineRedux

struct PeopleReducer: Reducer {
    typealias ActionType = PeopleAction
    typealias StateType = PeopleState
    
    func reduce(state: PeopleState, withTypedAction action: PeopleAction) -> ReducedState<PeopleState> {
        switch action {
        case .fetch:
            return .notChanged
        case .reload(let peoples):
            return .changed(state: state.with(\.peoples, equalTo: peoples))
        case .refresh:
            return .notChanged
        case .select(let people):
            return .changed(state: state.with(\.selectedPeople, equalTo: people))
        case .updateSelectedPeopleWithFilm(let film):
            var modifiedPeopleState = state
            modifiedPeopleState.selectedPeople?.films.append(film)
            return .changed(state: modifiedPeopleState)
        }
    }
}
