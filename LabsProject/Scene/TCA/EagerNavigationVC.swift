//
//  EagerNavigationVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/28.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

struct EagerNavigation: ReducerProtocol {
    struct State: Equatable {
        var isNavigationActive = false
        var optionalCounter: Counter.State?
    }
    
    enum Action {
        case optionalCounter(Counter.Action)
        case setNavigation(isActive: Bool)
        case setNavigationIsActiveDelayCompleted
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}

final class EagerNavigationVC: TCABaseVC<EagerNavigation> {
    
}
