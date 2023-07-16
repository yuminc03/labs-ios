//
//  TwoCountersVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/26.
//

import UIKit

import ComposableArchitecture
import SnapKit

final class TwoCountersVC: TCABaseVC<TwoCounters> {
        
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
    
    override func setup() {
        view.backgroundColor = .systemGray6
        view.addSubview(stackView)
        setNavigationTitle(title: "Two counters demo")
        
        [counter1, counter2].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
