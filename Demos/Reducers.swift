//
//  Reducers.swift
//  Demos
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import CombineRedux

struct AppReducer: UntypedActionReducer {
    typealias StateType = AppState
    
    func reduce(state: AppState, withAction action: Action) -> ReducedState<AppState> {
        var modifiedState = state
        
        if case let .changed(newState) = NotesReducer().reduce(state: state.notes, withAction: action) {
            modifiedState.notes = newState
        }
        
        if case let .changed(newState) = UserReducer().reduce(state: modifiedState, withAction: action) {
            modifiedState = newState
        }
        
        return modifiedState != state ? .changed(state: modifiedState) : .notChanged
    }
}

struct NotesReducer: Reducer {
    typealias StateType = Notes
    typealias ActionType = NoteActions
    
    func reduce(state: Notes, withTypedAction action: NoteActions) -> ReducedState<Notes> {
        switch action {
        case .fetch:
            return .notChanged
        case .increment:
            return .notChanged
        case .incremented(let notes):
            return .changed(state: state.with(\.wasIncremented, equalTo: true)
                                        .with(\.notes, equalTo: notes))
        case .reload(let notes):
            return .changed(state: state.with(\.notes, equalTo: notes))
        }
    }
}

struct UserReducer: Reducer {
    typealias StateType = AppState
    
    func reduce(state: AppState, withTypedAction action: UserActions) -> ReducedState<AppState> {
        switch action {
        case .login:
            return .notChanged
        case .loggedIn(let user):
            return .changed(state: state.with(\.loggedUser, equalTo: user))
        }
    }
}
