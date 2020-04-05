//
//  People.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

struct People: Equatable {
    let id: String
    let name: String
    let gender: String
    let age: String
    let eyeColor: String
    let hairColor: String
    let filmsURLS: [URL]
    let speciesURLS: [URL]
    let url: [URL]
    
    var films: [Film] = []
}
