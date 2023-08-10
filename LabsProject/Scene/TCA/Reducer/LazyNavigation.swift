//
//  LazyNavigation.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/30.
//

import Foundation
import Combine

import ComposableArchitecture

struct LazyNavigation: Reducer {
    
    struct State: Equatable {
        var optionalCounter: Counter.State?
        var isActivityIndicatorHidden = true
    }
    
    enum Action {
        case onDisappear
        case optionalCounter(Counter.Action)
        case setNavigation(isActive: Bool)
        case isSetNavigationActiveDelayCompleted
    }
    
    private enum CancelID {
        case load
    }
    @Dependency(\.continuousClock) var clock
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onDisappear:
                return .cancel(id: CancelID.load)
                
            case .setNavigation(isActive: true):
                state.isActivityIndicatorHidden = false
                return .run { send in
                    try await clock.sleep(for: .seconds(1))
                    await send(.isSetNavigationActiveDelayCompleted)
                }
                .cancellable(id: CancelID.load)
                
            case .setNavigation(isActive: false):
                state.optionalCounter = nil
                return .none
                
            case .isSetNavigationActiveDelayCompleted:
                state.isActivityIndicatorHidden = true
                state.optionalCounter = Counter.State()
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
