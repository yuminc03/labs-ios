//
//  TwoCountersVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/26.
//

import UIKit

import ComposableArchitecture
import SnapKit

struct TwoCounters: ReducerProtocol {
    struct State: Equatable {
        var counter1 = Counter.State()
        var counter2 = Counter.State()
    }
    
    enum Action: Equatable {
        case counter1(Counter.Action)
        case counter2(Counter.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
//        switch action {
//        case .counter1(let action):
//            Scope(state: state.counter1, action: action) {
//                Counter()
//            }
//            
//        case .counter2(let action):
//            Scope(state: state.counter2, action: action) {
//                Counter()
//            }
//        }
        return .none
    }
}

final class TwoCountersVC: BaseVC<TwoCounters> {
        
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    let counter1: CounterView
    let counter2: CounterView

    override init(store: StoreOf<TwoCounters>) {
        counter1 = CounterView(
            store: store.scope(
                state: \.counter1,
                action: TwoCounters.Action.counter1
            )
        )
        counter2 = CounterView(
            store: store.scope(
                state: \.counter2,
                action: TwoCounters.Action.counter2
            )
        )
        super.init(store: store)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        view.backgroundColor = .systemGray6
        view.addSubview(stackView)
        
        [counter1, counter2].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
