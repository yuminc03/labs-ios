//
//  BindingVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/02.
//

import UIKit
import Combine

import ComposableArchitecture
import SnapKit

final class BindingBasicsVC: TCABaseVC<BindingBasics> {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private let textFieldView: TextFieldView
    private let switchView: SwitchView
    private let stepperView: StepperView
    private let sliderView: SliderView

    override init(store: StoreOf<BindingBasics>) {
        self.textFieldView = TextFieldView(store: store)
        self.switchView = SwitchView(store: store)
        self.stepperView = StepperView(store: store)
        self.sliderView = SliderView(store: store)
        super.init(store: store)
    }
    
    init() {
        let store = Store(initialState: BindingBasics.State()) {
            BindingBasics()
        }
        self.textFieldView = TextFieldView(store: store)
        self.switchView = SwitchView(store: store)
        self.stepperView = StepperView(store: store)
        self.sliderView = SliderView(store: store)
        super.init(store: store)
    }
    
    override func setup() {
        super.setup()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        view.addSubview(containerView)
        setNavigationTitle(title: "Bindings basics")
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        [textFieldView, switchView, stepperView, sliderView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
}
