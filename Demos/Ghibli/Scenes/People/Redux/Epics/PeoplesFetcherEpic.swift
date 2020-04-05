//
//  PeoplesFetcherEpic.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import CombineRedux
import Combine

struct PeoplesFetcherEpic: SimpleEpic {
    typealias ActionType = PeopleAction
    typealias StateType = [People]
    
    func actionPublisherFor(actionsPublisher: AnyPublisher<PeopleAction, Never>, appStateGetter: @escaping () -> [People], oldAppStateGetter: @escaping () -> [People]) -> AnyPublisher<PeopleAction, Never> {
        
        actionsPublisher.flatMap { action -> AnyPublisher<PeopleAction, Never> in            
            let canFetch: Bool = { () -> Bool in
                switch action {
                case .fetch, .refresh:
                    return true
                case .reload, .select, .updateSelectedPeopleWithFilm:
                    return false
                }
            }()
            
            guard canFetch else { return Empty().eraseToAnyPublisher() }
            
            return Just(.reload(peoples: [
                People(id: "1", name: "Name 1", gender: "", age: "", eyeColor: "", hairColor: "", filmsURLS: [], speciesURLS: [], url: []),
                People(id: "2", name: "Name 2", gender: "", age: "", eyeColor: "", hairColor: "", filmsURLS: [], speciesURLS: [], url: [])
            ])).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
