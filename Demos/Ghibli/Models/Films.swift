//
//  Film.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

struct Film: Equatable {
    let id: String
    let title: String
    let description: String
    let director: String
    let producer: String
    let releaseDate: String
    let rtScore: String
    let people: [URL]
    let species: [URL]
    let locations: [URL]
    let vehicle: [URL]
    let url: URL
}
