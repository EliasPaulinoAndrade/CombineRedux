//
//  GHStore.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import CombineRedux
import Combine

class GHStore: Store<GHState, GHReducer> {
    static var shared = GHStore(
        state: GHState(),
        reducer: GHReducer(),
        epics: [
            EpicGroup(epic: PeoplesFetcherEpic(), keyPath: \GHState.peopleState.peoples).asAnyEpic,
            EpicGroup(epic: PeopleFetcherEpic(), keyPath: \GHState.peopleState.selectedPeople).asAnyEpic
        ]
    )
}

