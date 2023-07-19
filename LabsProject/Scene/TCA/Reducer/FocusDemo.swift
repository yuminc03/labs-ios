//
//  FocusDemo.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/19.
//

import Foundation

import ComposableArchitecture

struct FocusDemo: ReducerProtocol {

    enum Field: String, Hashable {
        case userName
        case password
    }
    
    struct State: Equatable {
        var userName = ""
        var password = ""
        var focusedField: Field?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case didChangeUserName(String)
        case didChangePassword(String)
        case didTapSignInButton
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding:
            return .none
            
        case .didChangeUserName(let userName):
            state.userName = userName
            return .none
            
        case .didChangePassword(let password):
            state.password = password
            return .none
            
        case .didTapSignInButton:
            if state.userName.isEmpty {
                state.focusedField = .userName
            } else if state.password.isEmpty {
                state.focusedField = .password
            }
            
            return .none
        }
    }
}
