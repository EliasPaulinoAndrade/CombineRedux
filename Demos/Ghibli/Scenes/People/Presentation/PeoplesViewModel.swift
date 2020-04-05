//
//  PeoplesViewModel.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import Combine

struct ListablePeople: Identifiable {
    let id: String
    let name: String
}

struct PeoplesViewModelInput {
    let peoples: AnyPublisher<[People], Never>
}

class PeoplesViewModelOutput {
    @Published var peoples: [ListablePeople] = []
}

class PeoplesViewModel {
    private let input: PeoplesViewModelInput
    lazy var output: PeoplesViewModelOutput = transform(input: input)
    
    private var cancellableStore: [AnyCancellable] = []
    
    init(input: PeoplesViewModelInput) {
        self.input = input
    }
    
    func transform(input: PeoplesViewModelInput) -> PeoplesViewModelOutput {
        let output = PeoplesViewModelOutput()
        
        input.peoples.map { peoples -> [ListablePeople] in
            return peoples.map { .init(id: $0.id, name: $0.name) }
        }.sink { names in
            output.peoples = names
        }.store(in: &cancellableStore)
        
        return output
    }
}
