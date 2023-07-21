//
//  EffectsBasicsVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/21.
//

import UIKit

import ComposableArchitecture
import SnapKit

struct EffectsBasics: ReducerProtocol {
    struct State: Equatable {
        var count = 0
        var isNumberFactRequestInFlight = false
        var numberFact: String?
    }
    
    enum Action {
        case didTapDecrementButton
        case didTapIncrementButton
        case didTapNumberButton
        case decrementDelayResponse
        case numberFactResponse(TaskResult<String>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}

final class EffectsBasicsVC: TCABaseVC<EffectsBasics> {
    
    
}
