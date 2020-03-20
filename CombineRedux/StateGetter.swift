//
//  StateGetter.swift
//  CombineRedux
//
//  Created by Elias Paulino on 19/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

public typealias StateGetter<StateType> = () -> StateType
