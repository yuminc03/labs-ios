//
//  OptionalBasicsVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/15.
//

import UIKit

import CombineCocoa
import ComposableArchitecture
import SnapKit

final class OptionalBasicsVC: TCABaseVC<OptionalBasics> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let toggleButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Toggle counter state"
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10)
        let view = UIButton(configuration: config)
        view.backgroundColor = .white
        view.setTitleColor(.systemBlue, for: .normal)
        return view
    }()

    private let separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        return view
    }()

    private let counterStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        return view
    }()
    
    private let stateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        return view
    }()
    
    private var counterView: CounterView?

    init() {
        let store = Store(
            initialState: OptionalBasics.State(),
            reducer: OptionalBasics()
        )
        super.init(store: store)
    }
    
    override func setup() {
        super.setup()
        view.backgroundColor = .systemGray6
        view.addSubview(stackView)
        setNavigationTitle(title: "Optional state")
                
        [toggleButton, separatorView1, counterStateView, separatorView2].forEach { subview in
            stackView.addArrangedSubview(subview)
        }
        counterStateView.addSubview(stateLabel)
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        separatorView1.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        separatorView2.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        toggleButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        counterStateView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        stateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        toggleButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapToggleCounterButton)
            }
            .store(in: &cancelBag)
        
        store.scope(
            state: \.optionalCounter,
            action: OptionalBasics.Action.optionalCounter
        ).ifLet(then: { [weak self] childStore in
            self?.stateLabel.text = "`CounterState` is non-`nil`"
            self?.counterView = CounterView(store: childStore)
            guard let counterView = self?.counterView else { return }
            self?.stackView.addArrangedSubview(counterView)
        }, else: { [weak self] in
            self?.stateLabel.text = "`CounterState` is `nil`"
            guard let counterView = self?.counterView else { return }
            counterView.removeFromSuperview()
            self?.counterView = nil
        })
        .store(in: &cancelBag)
    }
}
