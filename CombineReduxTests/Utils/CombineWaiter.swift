//
//  CombineWaiter.swift
//  CombineReduxTests
//
//  Created by Elias Paulino on 20/03/20.
//  Copyright © 2020 Elias Paulino. All rights reserved.
//

import Foundation
import Combine

class CombineWaiter<Input>: Subscriber {
    typealias Failure = Never
    private var subscription: Subscription?
            
    var results: [Input] = []
        
    func receive(subscription: Subscription) {
        self.subscription = subscription
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        results.append(input)
        return .unlimited
    }
    
    func receive(completion: Subscribers.Completion<Never>) { }
    
    @discardableResult
    static func wait(publisher: AnyPublisher<Input, Never>) -> CombineWaiter<Input> {
        let waiter = CombineWaiter<Input>()
        publisher.subscribe(waiter)
        return waiter
    }
}

