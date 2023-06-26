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
    
    private let navigationBar = NavigationBarView(title: "Counter")
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        view.alignment = .center
        return view
    }()

    private let minusButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "minus"), for: .normal)
        return view
    }()
    
    private let numberLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        return view
    }()

    private let plusButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        return view
    }()
    
    override func bind() {
        minusButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapDecrementButton)
            }
            .store(in: &cancelBag)
        
        plusButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapIncrementButton)
            }
            .store(in: &cancelBag)
        
        navigationBar.backButton.tapPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.value
            .sink { [weak self] value in
                self?.numberLabel.text = value.description
            }
            .store(in: &cancelBag)
    }
    
    override func setup() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        view.addSubview(navigationBar)
        
        stackView.addArrangedSubview(minusButton)
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(plusButton)
        
        navigationBar.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(109)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints {
            $0.width.height.equalTo(100)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(100)
        }
    }
}
