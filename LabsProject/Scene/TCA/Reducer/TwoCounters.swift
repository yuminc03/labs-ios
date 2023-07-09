//
//  TwoCounters.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/09.
//

import Foundation

import ComposableArchitecture

struct TwoCounters: ReducerProtocol {
    struct State: Equatable {
        var counter1 = Counter.State()
        var counter2 = Counter.State()
    }
    
    enum Action: Equatable {
        case counter1(Counter.Action)
        case counter2(Counter.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.counter1, action: /Action.counter1) {
            Counter()
        }
        Scope(state: \.counter2, action: /Action.counter2) {
            Counter()
        }
    }
}
