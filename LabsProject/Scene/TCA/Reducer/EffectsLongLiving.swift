//
//  EffectsLongLiving.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/23.
//

import Foundation
import UIKit

import ComposableArchitecture

struct EffectsLongLiving: Reducer {
    struct State: Equatable {
        var screenShotCount = 0
    }
    
    enum Action {
        case task
        case userDidTakeScreenShotNotification
    }
    
    @Dependency(\.screenshots) var screenshots
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .task:
            return .run { send in
                for await _ in await screenshots() {
                    await send(.userDidTakeScreenShotNotification)
                }
            }
            
        case .userDidTakeScreenShotNotification:
            state.screenShotCount += 1
            return .none
        }
    }
}

extension DependencyValues {
    var screenshots: @Sendable () async -> AsyncStream<Void> {
        get { self[ScreenshotsKey.self] }
        set { self[ScreenshotsKey.self] = newValue }
    }
}

private enum ScreenshotsKey: DependencyKey {
    static var liveValue: @Sendable () async -> AsyncStream<Void> = {
        await AsyncStream(
            NotificationCenter.default.notifications(
                named: UIApplication.userDidTakeScreenshotNotification
            ).map { _ in }
        )
    }
}
