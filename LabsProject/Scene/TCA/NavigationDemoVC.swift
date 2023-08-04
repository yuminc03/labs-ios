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
        Reduce {
            return .none
        }
        .ifLet(\.path, action: /Action.path) {
            Path()
        }
    }
    
    struct Path: ReducerProtocol {
        enum State: Codable, Equatable, Hashable {
            case screenA(ScreenA)
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
final class NavigationDemoVC: TCABaseVC<NavigationDemo> {
    
    init() {
        store = Store(
            initialState: NavigationDemo.State(),
            reducer: NavigationDemo())
        super.init(store: store)
    }
}

