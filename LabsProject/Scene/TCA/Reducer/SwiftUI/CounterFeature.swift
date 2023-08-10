//
//  CounterFeature.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/08/10.
//

import ComposableArchitecture

struct CounterFeature: Reducer {
    struct State: Equatable {
        var count = 0
    }
    
    enum Action {
        case didTapDecrementButton
        case didTapIncrementButton
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didTapDecrementButton:
            state.count -= 1
            return .none
            
        case .didTapIncrementButton:
            state.count += 1
            return .none
        }
    }
}
