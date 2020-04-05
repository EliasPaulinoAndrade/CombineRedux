//
//  GHState.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

struct GHState: Buildable {
    var peopleState: PeopleState = .init()
    var locations: [Location] = []
    var films: [Film] = []
}
