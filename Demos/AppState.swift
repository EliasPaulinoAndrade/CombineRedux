//
//  AppState.swift
//  Demos
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

struct User: Buildable, Equatable {
    var email: String
    var name: String
}

struct Notes: Buildable, Equatable {
    var notes: [String] = []
    var wasIncremented: Bool = false
}

struct AppState: Buildable, Equatable {
    var notes: Notes = .init()
    var loggedUser: User?
}
