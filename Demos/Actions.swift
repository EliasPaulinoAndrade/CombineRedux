//
//  Actions.swift
//  Demos
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import CombineRedux

enum NoteActions: Action {
    case fetch, increment, incremented(notes: [String]), reload(notes: [String])
}

enum UserActions: Action {
    case login, loggedIn(user: User)
}
