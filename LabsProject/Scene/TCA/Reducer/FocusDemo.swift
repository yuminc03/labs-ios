//
//  FocusDemo.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/19.
//

import Foundation

import ComposableArchitecture

struct FocusDemo: ReducerProtocol {

    struct State: Equatable {
        
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case didTapSignInButton
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}
