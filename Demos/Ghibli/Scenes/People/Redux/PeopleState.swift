//
//  PeopleState.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

struct PeopleState: Buildable {
    var peoples: [People] = []
    var selectedPeople: People? = nil
}
