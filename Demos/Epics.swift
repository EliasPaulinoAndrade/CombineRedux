//
//  Epics.swift
//  Demos
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import CombineRedux
import Combine

struct UserLoginMiddleware: SimpleEpic {
    typealias ActionType = UserActions
    typealias StateType = User?
    
    func actionPublisherFor(actionsPublisher: AnyPublisher<UserActions, Never>, appStateGetter: @escaping () -> User?, oldAppStateGetter: @escaping () -> User?) -> AnyPublisher<UserActions, Never> {
        actionsPublisher.flatMap { action -> AnyPublisher<UserActions, Never> in
            guard case .login = action else { return Empty().eraseToAnyPublisher() }
            
            return Just(.loggedIn(user: .init(email: "elias@gmail.com", name: "Elias"))).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}

struct FetcherMiddleware: UntypedActionEpic {
    typealias StateType = Notes
    
    func untypedActionsPublishersFor(actionPublisher: AnyPublisher<Action, Never>,
                   appStateGetter: @escaping StateGetter<Notes>,
                   oldAppStateGetter: @escaping StateGetter<Notes>) -> [AnyPublisher<Action, Never>] {
        [actionPublisher.flatMap { action -> AnyPublisher<Action, Never> in
            
            let canFetchNotes: Bool = {
                if let noteAction = action as? NoteActions, case .fetch = noteAction {
                    return true
                }
                if let userAction = action as? UserActions, case .loggedIn = userAction {
                    return true
                }
                return false
            }()

            guard canFetchNotes else { return Empty().eraseToAnyPublisher() }
            
            return Just(NoteActions.reload(notes: ["note1", "note2"])).eraseToAnyPublisher()
        }.eraseToAnyPublisher()]
    }
}

struct IncrementerMiddleware: SimpleEpic {
    typealias StateType = Notes
    typealias ActionType = NoteActions
    
    func actionPublisherFor(actionsPublisher: AnyPublisher<NoteActions, Never>,
                   appStateGetter: @escaping StateGetter<Notes>,
                   oldAppStateGetter: @escaping StateGetter<Notes>) -> AnyPublisher<NoteActions, Never> {

        actionsPublisher.flatMap { action -> AnyPublisher<NoteActions, Never> in
            guard case .increment = action else {
                return Empty().eraseToAnyPublisher()
            }
            var notes = appStateGetter().notes
            notes.append("incremented note \(notes.count + 1)")
            return Just(.incremented(notes: notes)).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}

struct PrinterMiddleware: SimpleEpic {
    typealias StateType = Notes
    typealias ActionType = NoteActions
    
    func actionPublisherFor(actionsPublisher: AnyPublisher<NoteActions, Never>,
                   appStateGetter: @escaping StateGetter<Notes>,
                   oldAppStateGetter: @escaping StateGetter<Notes>) -> AnyPublisher<NoteActions, Never> {
        actionsPublisher.flatMap { action -> AnyPublisher<NoteActions, Never> in
            guard let notes = PrinterMiddleware.notesToPrint(fromAction: action) else {
                return Empty().eraseToAnyPublisher()
            }
            print(PrinterMiddleware.stringToPrint(notes: notes, withTile: "Pretty Print"))
            if !appStateGetter().wasIncremented {
                return Just(.increment).eraseToAnyPublisher()
            }
            return Empty().eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    static private func stringToPrint(notes: [String], withTile title: String) -> String {
        let notesWidth = notes.max { (string1, string2) -> Bool in
            return string1.count < string2.count
        }?.count ?? 0
        
        let printWidth = max(notesWidth, title.count)
        
        return stringOfListInbox(list: [title], printWidth: printWidth) + "\n" +
               stringOfListInbox(list: notes, printWidth: printWidth)
    }
    
    static private func stringOfListInbox(list: [String], printWidth: Int) -> String {
        let printBorder = String(repeating: "-", count: printWidth)
        return "+" + printBorder + list.reduce("+\n", { total, currentNote -> String in
            "\(total)|\(currentNote)\(String(repeating: " ", count: printWidth-currentNote.count))|\n"
        }) + "+" + printBorder + "+"
    }
    
    static private func notesToPrint(fromAction action: NoteActions) -> [String]? {
        switch action {
        case .incremented(let notes):
            return notes
        case .reload(let notes):
            return notes
        default:
            return nil
        }
    }
}
