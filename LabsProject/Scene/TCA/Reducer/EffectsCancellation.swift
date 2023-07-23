//
//  EffectsCancellation.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/23.
//

import Foundation

import ComposableArchitecture

struct EffectsCancellation: ReducerProtocol {
    struct State: Equatable {
        var number = 0
        var isFactRequestInFlight = false
        var currentFact: String?
    }
    
    enum Action {
        case didTapCancelButton
        case didTapFactButton
        case didChangeStepper(Int)
        case factResponse(TaskResult<String>)
    }
    
    @Dependency(\.factClient) var factClient
    private enum CancelID {
        case factRequest
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapCancelButton:
            state.isFactRequestInFlight = false
            return .cancel(id: CancelID.factRequest)
            
        case .didTapFactButton:
            state.currentFact = nil
            state.isFactRequestInFlight = true
            
            return .run { [number = state.number] send in
                await send(.factResponse(TaskResult {
                    try await factClient.fetch(number)
                }))
            }
            .cancellable(id: CancelID.factRequest)
            
        case let .didChangeStepper(value):
            state.number = value
            state.currentFact = nil
            state.isFactRequestInFlight = false
            return .cancel(id: CancelID.factRequest)
            
        case let .factResponse(.success(response)):
            state.isFactRequestInFlight = false
            state.currentFact = response
            return .none
            
        case .factResponse(.failure):
            state.isFactRequestInFlight = false
            return .none
        }
    }
}
