//
//  CounterVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/26.
//

import UIKit
import Combine

import ComposableArchitecture
import SnapKit

struct Counter: ReducerProtocol {
    struct State: Equatable {
        var value = 0
    }
    
    enum Action {
        case didTapDecrementButton
        case didTapIncrementButton
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapDecrementButton:
            state.value -= 1
            return .none
            
        case .didTapIncrementButton:
            state.value += 1
            return .none
        }
    }
}

final class CounterVC: BaseVC<Counter> {
    
    private let counterView: CounterView
    
    override init(store: StoreOf<Counter>) {
        self.counterView = CounterView(store: store)
        super.init(store: store)
    }
    
    override func bind() {
        
    }
    
    override func setup() {
        view.addSubview(counterView)
        counterView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
