//
//  File.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/03.
//

import UIKit
import Combine

import SnapKit

final class StepperFormView: TCABaseView<BindingForm> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        return view
    }()
    
    private let textLabel: UILabel = {
        let view = UILabel()
        view.textColor = labsColor(.gray_2F2F2F)
        return view
    }()
    
    private let stepperView: UIStepper = {
        let view = UIStepper()
        view.stepValue = 1
        return view
    }()

    override func bind() {
        super.bind()
        stepperView.valuePublisher
            .sink { [weak self] value in
                self?.viewStore.send(.didChangeStepCount(Int(value)))
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.isToggleOn
            .sink { [weak self] isToggleOn in
                self?.stepperView.isEnabled = isToggleOn == false
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.stepCount
            .sink { [weak self] stepCount in
                self?.textLabel.text = "Max slider value: \(stepCount)"
            }
            .store(in: &cancelBag)
    }
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = .white
        addSubview(stackView)
        
        stepperView.value = Double(viewStore.stepCount)

        [textLabel, stepperView].forEach { subview in
            stackView.addArrangedSubview(subview)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
