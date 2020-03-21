//
//  Epic+epicGroup.swift
//  CombineRedux
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

public extension UntypedActionEpic {
    func epicGroup<ParentStateType>(keyPath: KeyPath<ParentStateType, StateType>) -> AnyEpic<ParentStateType> {        
        return [self].epicGroup(keyPath: keyPath)
    }
}
