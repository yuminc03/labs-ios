//
//  EffectsBasicsVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/21.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

struct EffectsBasics: ReducerProtocol {
    struct State: Equatable {
        var number = 0
        var isNumberFactRequestInFlight = false
        var numberFact: String?
    }
    
    enum Action {
        case didTapDecrementButton
        case didTapIncrementButton
        case didTapNumberFactButton
        case decrementDelayResponse
        case numberFactResponse(TaskResult<String>)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.factClient) var factClient
    private enum CancelID {
        case delay
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapDecrementButton:
            state.number -= 1
            state.numberFact = nil
            return state.number >= 0 ? .none : .run { send in
                try await clock.sleep(for: .seconds(1))
                await send(.decrementDelayResponse)
            }
            .cancellable(id: CancelID.delay)
            
        case .didTapIncrementButton:
            state.number += 1
            state.numberFact = nil
            return state.number >= 0 ? .cancel(id: CancelID.delay) : .none
            
        case .didTapNumberFactButton:
            state.isNumberFactRequestInFlight = true
            state.numberFact = nil
            // API에서 number fact를 가져와서 reducer의 numberFactResponse action에 값을 반환하는 effect를 리턴
            return .run { [count = state.number] send in
                await send(.numberFactResponse(TaskResult { try await
                    self.factClient.fetch(count)
                }))
            }
            
        case .decrementDelayResponse:
            guard state.number < 0 else {
                return .none
            }
            
            state.number += 1
            return .none
            
        case let .numberFactResponse(.success(response)):
            state.isNumberFactRequestInFlight = false
            state.numberFact = response
            return .none
            
        case .numberFactResponse(.failure):
            state.isNumberFactRequestInFlight = false
            return .none
        }
    }
}

final class EffectsBasicsVC: TCABaseVC<EffectsBasics> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let counterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let counterStackView: UIStackView = {
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
    
    private let numberFactButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Number fact"
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
    
    override func setup() {
        super.setup()
        view.backgroundColor = .systemGray6
        view.addSubview(stackView)
        setNavigationTitle(title: "Effects")
        
        stackView.addArrangedSubview(counterContainerView)
        stackView.addArrangedSubview(separatorView1)
        stackView.addArrangedSubview(numberFactButton)
        
        counterContainerView.addSubview(counterStackView)
        counterStackView.addArrangedSubview(minusButton)
        counterStackView.addArrangedSubview(numberLabel)
        counterStackView.addArrangedSubview(plusButton)
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        counterStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.centerX.centerY.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        separatorView1.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        numberFactButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewStore.publisher.number
            .sink { [weak self] count in
                self?.numberLabel.text = count.description
            }
            .store(in: &cancelBag)
        
        minusButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapDecrementButton)
            }
            .store(in: &cancelBag)
        
        plusButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapIncrementButton)
            }
            .store(in: &cancelBag)
    }
}
