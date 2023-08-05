//
//  NavigationDemo.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/08/05.
//

import Foundation

import ComposableArchitecture

struct NavigationDemo: ReducerProtocol {
    struct State: Equatable {
        var path = StackState<Path.State>()
        let rowTitles = [
            "Go to screen A",
            "Go to screen B",
            "Go to screen C",
            "Go to A → B → C"
        ]
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
