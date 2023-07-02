//
//  SliderFormView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/03.
//

import UIKit
import Combine

import SnapKit

final class SliderFormView: BaseView<BindingForm> {
    
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
    
    private let sliderView: UISlider = {
        let view = UISlider()
        view.maximumValue = 10
        return view
    }()

    override func bind() {
        super.bind()
        
        sliderView.valuePublisher
            .sink { [weak self] value in
                self?.viewStore.send(.didChangeSliderValue(Double(value)))
                self?.textLabel.text = "Slider value: \(Int(value))"
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.isToggleOn
            .sink { [weak self] isToggleOn in
                self?.sliderView.isEnabled = isToggleOn == false
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.sliderValue
            .sink { [weak self] sliderValue in
                self?.sliderView.value = Float(sliderValue)
            }
            .store(in: &cancelBag)
    }
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = .white
        addSubview(stackView)
        
        sliderView.value = Float(viewStore.sliderValue)

        [textLabel, sliderView].forEach { subview in
            stackView.addArrangedSubview(subview)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sliderView.snp.makeConstraints {
            $0.width.equalTo(150)
        }
    }
}
