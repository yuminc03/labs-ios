//
//  EffectsCancellationVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/23.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

final class EffectsCancellationVC: TCABaseVC<EffectsCancellation> {
    
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
        view.distribution = .fill
        return view
    }()

    private let numberLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        return view
    }()
    
    private let stepperView: UIStepper = {
        let view = UIStepper()
        view.minimumValue = -100
        view.maximumValue = 100
        return view
    }()

    private let separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        return view
    }()

    private let numberFactButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Number fact"
        config.titleAlignment = .leading
        config.imagePlacement = .trailing
        config.imagePadding = UIScreen.main.bounds.width - 220
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10)
        let view = UIButton(configuration: config)
        view.backgroundColor = .white
        view.setTitleColor(.systemBlue, for: .normal)
        return view
    }()
    
    private let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        return view
    }()
    
    private let numberFactView: NumberFactView = {
        let view = NumberFactView()
        view.backgroundColor = .white
        return view
    }()
    
    init() {
        let store = Store(initialState: EffectsCancellation.State()) {
            EffectsCancellation()
        }
        super.init(store: store)
    }
    
    override func setup() {
        super.setup()
        setNavigationTitle(title: "Effect cancellation")
        view.backgroundColor = .systemGray6
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(counterContainerView)
        stackView.addArrangedSubview(separatorView1)
        stackView.addArrangedSubview(numberFactButton)
        stackView.addArrangedSubview(separatorView2)
        stackView.addArrangedSubview(numberFactView)
        
        counterContainerView.addSubview(counterStackView)
        counterStackView.addArrangedSubview(numberLabel)
        counterStackView.addArrangedSubview(stepperView)
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        counterStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        separatorView1.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        numberFactButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        separatorView2.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewStore.publisher.number
            .sink { [weak self] number in
                self?.numberLabel.text = number.description
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.isFactRequestInFlight
            .combineLatest(viewStore.publisher.currentFact)
            .sink { [weak self] (isFact, currentFact) in
                self?.numberFactButton.configuration?.showsActivityIndicator = isFact
                self?.separatorView2.isHidden = currentFact == nil
                self?.numberFactView.isHidden = currentFact == nil
                self?.numberFactView.updateUI(numberFact: currentFact)
            }
            .store(in: &cancelBag)
        
        stepperView.valuePublisher
            .map { Int($0) }
            .sink { [weak self] value in
                self?.viewStore.send(.didChangeStepper(value))
            }
            .store(in: &cancelBag)
        
        numberFactButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapFactButton)
            }
            .store(in: &cancelBag)
    }
}
