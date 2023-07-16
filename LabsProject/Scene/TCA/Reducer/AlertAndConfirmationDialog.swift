//
//  AlertAndConfirmationDialog.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/16.
//

import Foundation

import ComposableArchitecture

struct AlertAndConfirmationDialog: ReducerProtocol {
    
    struct State: Equatable {
        var alert: AlertState<Action>?
        var confirmationDialog: ConfirmationDialogState<Action>?
        var currentCount = 0
    }
    
    enum Action: Equatable {
        case didTapAlertButton
        case alertDismissed
        case didTapConfirmationDialogButton
        case confirmationDialogDismissed
        case didTapDecrementButton
        case didTapIncrementButton
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapAlertButton:
            state.alert = AlertState(title: {
                TextState("Alert!")
            }, actions: {
                ButtonState(role: .cancel) {
                    TextState("Cancel")
                }
                ButtonState(action: .didTapIncrementButton) {
                    TextState("Increment")
                }
            }, message: {
                TextState("This is an alert")
            })
            return .none
            
        case .alertDismissed:
            state.alert = nil
            return .none
            
        case .didTapConfirmationDialogButton:
            state.confirmationDialog = ConfirmationDialogState(title: {
                TextState("Confirmation dialog")
            }, actions: {
                ButtonState(role: .cancel) {
                    TextState("Cancel")
                }
                ButtonState(action: .didTapIncrementButton) {
                    TextState("Increment")
                }
                ButtonState(action: .didTapDecrementButton) {
                    TextState("Decrement")
                }
            }, message: {
                TextState("This is a confirmation dialog.")
            })
            return .none
            
        case .confirmationDialogDismissed:
            state.confirmationDialog = nil
            return .none
            
        case .didTapDecrementButton:
            state.alert = AlertState {
                TextState("Decremented!")
            }
            state.currentCount -= 1
            return .none
            
        case .didTapIncrementButton:
            state.alert = AlertState {
                TextState("Incremented!")
            }
            state.currentCount += 1
            return .none
        }
    }
}
