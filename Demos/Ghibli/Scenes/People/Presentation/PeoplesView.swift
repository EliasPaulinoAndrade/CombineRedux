//
//  PeoplesView.swift
//  Demos
//
//  Created by Elias Paulino on 04/04/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import SwiftUI
import Combine

struct PeoplesView: View {
    var viewModel: PeoplesViewModel
    var body: some View {
        List(viewModel.output.peoples) {  people in
            Text(people.name)
        }
    }
}

struct PeoplesView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleViewFactory().view()
    }
}
