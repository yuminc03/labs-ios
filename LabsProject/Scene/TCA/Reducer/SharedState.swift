//
//  SharedState.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/16.
//

import Foundation

import ComposableArchitecture

struct SharedState: ReducerProtocol {
    
    enum Tab: Int {
        case counter
        case profile
    }
    
    struct State: Equatable {
        var counter = Counter.State()
        var currentTab = Tab.counter
        var profile: Profile.State {
            get {
                Profile.State(
                    currentTab: self.currentTab,
                    currentCount: self.counter.currentCount,
                    maxCount: self.counter.maxCount,
                    minCount: self.counter.minCount,
                    numberOfCounts: self.counter.numberOfCounts
                )
            }
            set {
                self.currentTab = newValue.currentTab
                self.counter.currentCount = newValue.currentCount
                self.counter.maxCount = newValue.maxCount
                self.counter.minCount = newValue.minCount
                self.counter.numberOfCounts = newValue.numberOfCounts
            }
        }
    }
    
    enum Action: Equatable {
        case counter(Counter.Action)
        case profile(Profile.Action)
        case selectTab(Tab)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.counter, action: /Action.counter) {
            Counter()
        }
        
        Scope(state: \.profile, action: /Action.profile) {
            Profile()
        }
        
        Reduce { state, action in
            switch action {
            case .counter, .profile:
                return .none
            case let .selectTab(tab):
                state.currentTab = tab
                return .none
            }
        }
    }
    
    struct Profile: ReducerProtocol {
        
        struct State: Equatable {
            private(set) var currentTab: Tab
            private(set) var currentCount = 0
            private(set) var maxCount: Int
            private(set) var minCount: Int
            private(set) var numberOfCounts: Int
            
            fileprivate mutating func resetCount() {
                self.currentTab = .counter
                self.currentCount = 0
                self.maxCount = 0
                self.minCount = 0
                self.numberOfCounts = 0
            }
        }
        
        enum Action: Equatable {
            case didTapResetCounterButton
        }
        
        func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
            switch action {
            case .didTapResetCounterButton:
                state.resetCount()
                return .none
            }
        }
    }
    
    struct Counter: ReducerProtocol {
        
        struct State: Equatable {
            var alert: AlertState<Action>?
            var currentCount = 0
            var maxCount = 0
            var minCount = 0
            var numberOfCounts = 0
        }
        
        enum Action: Equatable {
            case alertDismissed
            case didTapDecrementButton
            case didTapIncrementButton
            case didTapIsPrimeButton
        }
        
        func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
            switch action {
            case .alertDismissed:
                state.alert = nil
                return .none
                
            case .didTapDecrementButton:
                state.currentCount -= 1
                state.numberOfCounts -= 1
                state.minCount = min(state.minCount, state.currentCount)
                return .none
                
            case .didTapIncrementButton:
                state.currentCount += 1
                state.numberOfCounts += 1
                state.maxCount = max(state.maxCount, state.currentCount)
                return .none
                
            case .didTapIsPrimeButton:
                state.alert = AlertState {
                    TextState(
                        isPrime(state.currentCount) ? "👍 The number \(state.currentCount) is prime!" : "👎 The number \(state.currentCount) is not prime :("
                    )
                }
                return .none
            }
        }
    }
}

private func isPrime(_ p: Int) -> Bool {
    if p <= 1 { return false }
    if p <= 3 { return true }
    for i in 2 ... Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
    }
    return true
}
