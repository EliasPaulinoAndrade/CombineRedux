//
//  Epic+asAnyEpic.swift
//  CombineRedux
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

extension UntypedActionEpic {
    
    /// returns a type erased from the epic. Use it when you need save multiple references of different types of Epics.
    var asAnyEpic: AnyEpic<StateType> {
        return .init(epic: self)
    }
}
