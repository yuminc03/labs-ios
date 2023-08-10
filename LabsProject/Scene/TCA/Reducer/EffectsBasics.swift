//
//  EffectsBasics.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/23.
//

import Foundation

import ComposableArchitecture

struct EffectsBasics: Reducer {
    struct State: Equatable {
        var number = 0
        var isNumberFactRequestInFlight = false
        var numberFact: String?
    }
    
    enum Action {
        case didTapDecrementButton
        case didTapIncrementButton
        case didTapNumberFactButton
        case decrementDelayResponse
        case numberFactResponse(TaskResult<String>)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.factClient) var factClient
    private enum CancelID {
        case delay
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didTapDecrementButton:
            state.number -= 1
            state.numberFact = nil
            return state.number >= 0 ? .none : .run { send in
                try await clock.sleep(for: .seconds(1))
                await send(.decrementDelayResponse)
            }
            .cancellable(id: CancelID.delay)
            
        case .didTapIncrementButton:
            state.number += 1
            state.numberFact = nil
            return state.number >= 0 ? .cancel(id: CancelID.delay) : .none
            
        case .didTapNumberFactButton:
            state.isNumberFactRequestInFlight = true
            state.numberFact = nil
            // API에서 number fact를 가져와서 reducer의 numberFactResponse action에 값을 반환하는 effect를 리턴
            return .run { [count = state.number] send in
                await send(.numberFactResponse(TaskResult {
                    try await factClient.fetch(count)
                }))
            }
            
        case .decrementDelayResponse:
            guard state.number < 0 else {
                return .none
            }
            
            state.number += 1
            return .none
            
        case let .numberFactResponse(.success(response)):
            state.isNumberFactRequestInFlight = false
            state.numberFact = response
            return .none
            
        case .numberFactResponse(.failure):
            state.isNumberFactRequestInFlight = false
            return .none
        }
    }
}
