//
//  PeopleFetcherEpic.swift
//  Demos
//
//  Created by Elias Paulino on 05/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import CombineRedux
import Combine

struct PeopleFetcherEpic: SimpleEpic {
    typealias ActionType = PeopleAction
    typealias StateType = People?
    
    func actionPublisherFor(actionsPublisher: AnyPublisher<PeopleAction, Never>, appStateGetter: @escaping () -> People?, oldAppStateGetter: @escaping () -> People?) -> AnyPublisher<PeopleAction, Never> {
        
        return actionsPublisher.flatMap { action -> AnyPublisher<PeopleAction, Never> in
            guard case let .select(people) = action else { return Empty().eraseToAnyPublisher() }
                        
            let filmPublishers = people.filmsURLS.map { filmURL -> AnyPublisher<PeopleAction, Never> in
                return Just(.updateSelectedPeopleWithFilm(film: Film(id: "", title: "Film", description: "", director: "", producer: "", releaseDate: "", rtScore: "", people: [], species: [], locations: [], vehicle: [], url: URL(string: "www.dfw.com")!))).eraseToAnyPublisher()
            }

            return Publishers.MergeMany(filmPublishers).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
