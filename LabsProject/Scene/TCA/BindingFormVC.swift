//
//  BindingFormVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/02.
//

import UIKit
import Combine

import ComposableArchitecture
import SnapKit

struct BindingForm: ReducerProtocol {
    
    struct State: Equatable {
        var sliderValue = 5.0
        var stepCount = 10
        var text = ""
        var isToggleOn = false
    }
    
    enum Action: Equatable {
        case didChangeSliderValue(Double)
        case didChangeStepCount(Int)
        case didChangeText(String)
        case didChangeToggle(isOn: Bool)
        case didTapResetButton
    }
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case .didChangeSliderValue(let value):
            state.sliderValue = value
            return .none
            
        case .didChangeStepCount(let count):
            state.sliderValue = .minimum(state.sliderValue, Double(count))
            state.stepCount = count
            return .none
            
        case .didChangeText(let text):
            state.text = text
            return .none
            
        case .didChangeToggle(let isOn):
            state.isToggleOn = isOn
            return .none
            
        case .didTapResetButton:
            state = State()
            return .none
        }
    }
}

final class BindingFormVC: TCABaseVC<BindingForm> {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private let textFieldView: TextFieldFormView
    private let switchView: SwitchFormView
    private let stepperView: StepperFormView
    private let sliderView: SliderFormView
    
    private let resetButton: UIButton = {
        let view = UIButton()
        view.setTitle("Reset", for: .normal)
        view.setTitleColor(.systemRed, for: .normal)
        return view
    }()

    override init(store: StoreOf<BindingForm>) {
        self.textFieldView = TextFieldFormView(store: store)
        self.switchView = SwitchFormView(store: store)
        self.stepperView = StepperFormView(store: store)
        self.sliderView = SliderFormView(store: store)
        super.init(store: store)
    }
    
    override func bind() {
        super.bind()
        resetButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapResetButton)
            }
            .store(in: &cancelBag)
    }
    
    override func setup() {
        super.setup()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        view.addSubview(containerView)
        setNavigationTitle(title: "TCA - BindingBasicsView")
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        [textFieldView, switchView, stepperView, sliderView, resetButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
}
