//
//  ActionsMock.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
@testable import CombineRedux

struct TestAction2: Action, Equatable { }
enum TestAction: Action, Equatable {
    case state1, state2
    
    init() {
        self = .state1
    }
}
