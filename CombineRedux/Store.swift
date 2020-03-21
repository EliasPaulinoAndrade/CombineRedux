//
//  Store.swift
//  CombineRedux
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
// 

import Foundation
import Combine

public class Store<StateType, ReducerType: UntypedActionReducer>: Publisher where ReducerType.StateType == StateType {
    public typealias Output = StateType
    public typealias Failure = Never
    public typealias EpicType = AnyEpic<StateType>
    
    private let initalState: StateType
    private let reducer: ReducerType
    private let epics: [EpicType]
    
    private let actionSubject = PassthroughSubject<Action, Never>()
    lazy private var oldStateSubject = CurrentValueSubject<StateType, Never>(initalState)
    lazy private var stateSubject = CurrentValueSubject<StateType, Never>(initalState)
    
    private var cancellableStore: [AnyCancellable] = []
    
    public init(state: StateType, reducer: ReducerType, epics: [EpicType]) {
        self.initalState = state
        self.reducer = reducer
        self.epics = epics
        
        Store.bindEpics(epics: epics,
                        actionsPublisher: actionSubject.eraseToAnyPublisher(),
                        appStateGetter: getState, oldAppStateGetter: getOldState,
                        dispatcher: dispatch,
                        cancellableStore: &cancellableStore)
    }
    
    public convenience init(state: StateType, reducer: ReducerType, epics: EpicType...) {
        self.init(state: state, reducer: reducer, epics: epics)
    }
    
    static func bindEpics(epics: [EpicType],
                          actionsPublisher: AnyPublisher<Action, Never>,
                          appStateGetter: @escaping StateGetter<StateType>,
                          oldAppStateGetter: @escaping StateGetter<StateType>,
                          dispatcher: @escaping (Action) -> Void,
                          cancellableStore: inout [AnyCancellable]) {
        epics.forEach { epic in
            epic.untypedActionsPublishersFor(
                actionPublisher: actionsPublisher,
                appStateGetter: appStateGetter,
                oldAppStateGetter: oldAppStateGetter
            ).forEach {
                $0.sink(receiveValue: dispatcher)
                  .store(in: &cancellableStore)
            }
        }
    }
    
    public func getState() -> StateType {
        return self.stateSubject.value
    }
    
    public func getOldState() -> StateType {
        return self.oldStateSubject.value
    }
    
    public func dispatch(action: Action) {
        if case let ReducedState.changed(state: newState) = reducer.reduce(state: stateSubject.value, withAction: action) {
            oldStateSubject.send(stateSubject.value)
            stateSubject.send(newState)
        }

        actionSubject.send(action)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, StateType == S.Input {
        stateSubject.receive(subscriber: subscriber)
    }
    
    public func mapIfChanged<ValueType: Equatable>(keyPath: KeyPath<StateType, ValueType>) -> AnyPublisher<ValueType, Never> {
        map(keyPath).filter { [unowned self] currentState -> Bool in
            currentState != self.oldStateSubject.value[keyPath: keyPath]
        }.eraseToAnyPublisher()
    }
}
