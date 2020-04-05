//
//  PeopleAction.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import CombineRedux

enum PeopleAction: Action {
    case fetch, reload(peoples: [People]), refresh, select(people: People), updateSelectedPeopleWithFilm(film: Film)
}
