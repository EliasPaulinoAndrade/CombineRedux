//
//  AppDelegate.swift
//  Demos
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import UIKit
import CombineRedux
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let notesEpic = EpicGroup(
            subEpics: [
                PrinterMiddleware().asAnyEpic,
                IncrementerMiddleware().asAnyEpic,
                FetcherMiddleware().asAnyEpic
            ],
            keyPath: \AppState.notes
        ).asAnyEpic

        let userEpics = EpicGroup(epic: UserLoginMiddleware().asAnyEpic, keyPath: \AppState.loggedUser?).asAnyEpic
            
        let store = Store(state: AppState(), reducer: AppReducer(), epics: [
            notesEpic,
            userEpics,
        ])

        var cancellableStore: [AnyCancellable] = []

        store.sink { appState in
            print("#1 - ", appState)
        }.store(in: &cancellableStore)

        store.sink { appState in
            print("#2 - ", appState)
        }.store(in: &cancellableStore)

        store.mapIfChanged(keyPath: \.loggedUser).sink { user in
            print("#-------->UserChanged: ", user)
        }.store(in: &cancellableStore)

        store.mapIfChanged(keyPath: \.notes).sink { notes in
            print("#-------->NotesChanged: ", notes)
        }.store(in: &cancellableStore)

        store.mapIfChanged(keyPath: \.notes.wasIncremented).sink { incremented in
            print("#-------->WasIncrementedChanged: ", incremented)
        }.store(in: &cancellableStore)

        store.dispatch(action: UserActions.login)
        
        return true
    }
}

