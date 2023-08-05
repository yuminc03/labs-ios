//
//  ScreenC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/08/05.
//

import Foundation

import ComposableArchitecture

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
