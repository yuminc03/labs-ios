//
//  Counter.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/09.
//

import Foundation

import ComposableArchitecture

struct Counter: Reducer {
    struct State: Equatable, Identifiable {
        let id = UUID()
        var value = 0
    }
    
    enum Action: Equatable {
        case didTapDecrementButton
        case didTapIncrementButton
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
