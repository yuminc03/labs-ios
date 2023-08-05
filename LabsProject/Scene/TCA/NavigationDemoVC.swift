//
//  NavigationDemoVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/31.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

struct NavigationDemo: ReducerProtocol {
    struct State: Equatable {
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case goBackToScreen(id: StackElementID)
        case didTapGoToABCButton
        case path(StackAction<Path.State, Path.Action>)
        case popToRoot
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .goBackToScreen(id):
                state.path.pop(to: id)
                return .none
                
            case .didTapGoToABCButton:
                state.path.append(.screenA())
                state.path.append(.screenB())
                state.path.append(.screenC())
                return .none
                
            case let .path(action):
                switch action {
                case .element(id: _, action: .screenB(.didTapScreenAButton)):
                    state.path.append(.screenA())
                    return .none
                    
                case .element(id: _, action: .screenB(.didTapScreenBButton)):
                    state.path.append(.screenB())
                    return .none
                    
                case .element(id: _, action: .screenB(.didTapScreenCButton)):
                    state.path.append(.screenC())
                    return .none
                    
                default:
                    return .none
                }
                
            case .popToRoot:
                state.path.removeAll()
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
    
    struct Path: ReducerProtocol {
        enum State: Codable, Equatable, Hashable {
            case screenA(ScreenA.State = .init())
            case screenB(ScreenB.State = .init())
            case screenC(ScreenC.State = .init())
        }
        
        enum Action {
            case screenA(ScreenA.Action)
            case screenB(ScreenB.Action)
            case screenC(ScreenC.Action)
        }
        
        var body: some ReducerProtocol<State, Action> {
            Scope(state: /State.screenA, action: /Action.screenA) {
                ScreenA()
            }
            Scope(state: /State.screenB, action: /Action.screenB) {
                ScreenB()
            }
            Scope(state: /State.screenC, action: /Action.screenC) {
                ScreenC()
            }
        }
    }
}

struct ScreenA: ReducerProtocol {
    struct State: Codable, Equatable, Hashable {
        var count = 0
        var fact: String?
        var isLoading = false
    }
    
    enum Action: Equatable {
        case didTapDecrementButton
        case didTapDismissButton
        case didTapIncrementButton
        case didTapFactButton
        case factResponse(TaskResult<String>)
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.factClient) var factClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapDecrementButton:
            state.count -= 1
            return .none
            
        case .didTapDismissButton:
            return .fireAndForget {
                await dismiss()
            }
            
        case .didTapIncrementButton:
            state.count += 1
            return .none
            
        case .didTapFactButton:
            state.isLoading = true
            return .task { [count = state.count] in
                await .factResponse(.init { try await
                    factClient.fetch(count)
                })
            }
            
        case let .factResponse(.success(fact)):
            state.isLoading = false
            state.fact = fact
            return .none
            
        case .factResponse(.failure):
            state.isLoading = false
            state.fact = nil
            return .none
        }
    }
}

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

struct ScreenC: ReducerProtocol {
    struct State: Codable, Equatable, Hashable {
        var count = 0
        var isTimerRunning = false
    }
    
    enum Action {
        case didTapStartButton
        case didTapStopButton
        case timerTick
    }
    
    @Dependency(\.mainQueue) var mainQueue
    enum CancelID {
        case timer
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapStartButton:
            state.isTimerRunning = true
            return .run { send in
                for await _ in mainQueue.timer(interval: 1) {
                    await send(.timerTick)
                }
            }
            .cancellable(id: CancelID.timer)
            .concatenate(with: .init(value: .didTapStopButton))
            
        case .didTapStopButton:
            state.isTimerRunning = false
            return .cancel(id: CancelID.timer)
            
        case .timerTick:
            state.count += 1
            return .none
        }
    }
}

final class NavigationDemoVC: TCABaseVC<NavigationDemo> {
    
    init() {
        let store = Store(
            initialState: NavigationDemo.State(),
            reducer: NavigationDemo())
        super.init(store: store)
    }
}
