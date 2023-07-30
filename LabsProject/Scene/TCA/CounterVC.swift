//
//  CounterVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/26.
//

import UIKit

import ComposableArchitecture
import SnapKit

final class CounterVC: TCABaseVC<Counter> {
    
    private let counterView: CounterView
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    init() {
        let store = Store(
            initialState: Counter.State(),
            reducer: Counter()
         )
        self.counterView = CounterView(store: store)
        super.init(store: store)
    }
    
    override init(store: StoreOf<Counter>) {
        self.counterView = CounterView(store: store)
        super.init(store: store)
    }
    
    override func setup() {
        setNavigationTitle(title: "Counter demo")
        view.backgroundColor = .systemGray6
        view.addSubview(stackView)
        stackView.addArrangedSubview(counterView)
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
