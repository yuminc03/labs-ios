//
//  Counter.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/09.
//

import Foundation

import ComposableArchitecture

struct Counter: ReducerProtocol {
    struct State: Equatable {
        var value = 0
    }
    
    enum Action {
        case didTapDecrementButton
        case didTapIncrementButton
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapDecrementButton:
            state.value -= 1
            return .none
            
        case .didTapIncrementButton:
            state.value += 1
            return .none
        }
    }
}
