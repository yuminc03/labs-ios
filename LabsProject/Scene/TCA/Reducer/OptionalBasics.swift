//
//  OptionalBasics.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/15.
//

import ComposableArchitecture

struct OptionalBasics: ReducerProtocol {
    struct State: Equatable {
        var optionalCounter: Counter.State?
    }
    
    enum Action: Equatable {
        case optionalCounter(Counter.Action)
        case didTapToggleCounterButton
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTapToggleCounterButton:
                state.optionalCounter = state.optionalCounter == nil ? Counter.State() : nil
                return .none
                
            case .optionalCounter:
                return .none
            }
        }
        .ifLet(\.optionalCounter, action: /Action.optionalCounter) {
            Counter()
        }
    }
}
