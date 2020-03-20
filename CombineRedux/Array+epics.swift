//
//  Array+epics.swift
//  CombineRedux
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

public extension Array where Element: UntypedActionEpic {
    func epicGroup<StateType>(keyPath: KeyPath<StateType, Element.StateType>) -> AnyEpic<StateType> {
        return EpicGroup<Element, StateType, Element.StateType>(subEpics: self, keyPath: keyPath).asAnyEpic
    }
}
