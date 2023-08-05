//
//  ScreenB.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/08/05.
//

import Foundation

import ComposableArchitecture

struct ScreenB: ReducerProtocol {
    struct State: Codable, Equatable, Hashable {
        
    }
    
    enum Action {
        case didTapScreenAButton
        case didTapScreenBButton
        case didTapScreenCButton
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapScreenAButton:
            return .none
            
        case .didTapScreenBButton:
            return .none
            
        case .didTapScreenCButton:
            return .none
        }
    }
}
