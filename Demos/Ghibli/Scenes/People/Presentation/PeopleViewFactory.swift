//
//  PeopleViewFactory.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation

struct PeopleViewFactory {
    func view() -> PeoplesView {
        let view = PeoplesView(viewModel:
            .init(input: PeoplesViewModelInput(peoples:
                GHStore.shared.map(\.peopleState.peoples).eraseToAnyPublisher()
            )
        ))
        GHStore.shared.dispatch(action: PeopleAction.fetch)
        return view
    }
}
