//
//  Refreshable.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/26.
//

import Foundation

import ComposableArchitecture

struct Refreshable: ReducerProtocol {
    struct State: Equatable {
        var counter = Counter.State()
        var fact: String?
    }
    
    enum Action {
        case counter(Counter.Action)
        case didTapCancelButton
        case factResponse(TaskResult<String>)
        case refresh
    }
    
    @Dependency(\.factClient) var factClient
    private enum CancelID {
        case factRequest
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.counter, action: /Action.counter) {
            Counter()
        }
        Reduce { state, action in
            switch action {
            case .didTapCancelButton:
                return .cancel(id: CancelID.factRequest)
                
            case let .factResponse(.success(fact)):
                state.fact = fact
                return .none
                
            case .factResponse(.failure):
                return .none
                
            case .refresh:
                state.fact = nil
                return .run { [number = state.counter.value] send in
                    await send(
                        .factResponse(TaskResult { try await factClient.fetch(number) }),
                        animation: .default
                    )
                }
                .cancellable(id: CancelID.factRequest)
                
            default:
                return .none
            }
        }
    }
}
