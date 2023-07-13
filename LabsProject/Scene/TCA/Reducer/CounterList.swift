//
//  CounterList.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/11.
//

import Foundation

import ComposableArchitecture

struct CounterList: ReducerProtocol {
    struct State: Equatable {
        var counters: IdentifiedArrayOf<Counter.State> = []
    }
    
    enum Action: Equatable {
        case counter(id: Counter.State.ID, action: Counter.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
            .forEach(\.counters, action: /Action.counter) {
                Counter()
            }
    }
}
