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
}
final class NavigationDemoVC: TCABaseVC<NavigationDemo> {
    
    init() {
        store = Store(
            initialState: NavigationDemo.State(),
            reducer: NavigationDemo.Action)
        super.init(store: store)
    }
}
