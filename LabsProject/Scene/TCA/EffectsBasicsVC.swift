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
    
    private let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        return view
    }()
    
    private let progressView: ProgressView = {
        let view = ProgressView()
        view.backgroundColor = .white
        return view
    }()
    
    init() {
        let store = Store(
            initialState: EffectsBasics.State(),
            reducer: EffectsBasics()
        )
        super.init(store: store)
    }
    
    override func setup() {
        super.setup()
        view.backgroundColor = .systemGray6
        view.addSubview(stackView)
        setNavigationTitle(title: "Effects")
        
        stackView.addArrangedSubview(counterContainerView)
        stackView.addArrangedSubview(separatorView1)
        stackView.addArrangedSubview(numberFactButton)
        stackView.addArrangedSubview(separatorView2)
        stackView.addArrangedSubview(progressView)
        
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
        
        separatorView2.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewStore.publisher.number
            .sink { [weak self] count in
                self?.numberLabel.text = count.description
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.isNumberFactRequestInFlight
            .combineLatest(viewStore.publisher.numberFact)
            .sink { [weak self] isNumberFact, numberFact in
                self?.separatorView2.isHidden = isNumberFact == false && numberFact == nil
                self?.progressView.isHidden = isNumberFact == false && numberFact == nil
                self?.progressView.updateIndicator(isLoading: isNumberFact)
                self?.progressView.updateUI(numberFact: numberFact)
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
        
        numberFactButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapNumberFactButton)
            }
            .store(in: &cancelBag)
    }
}
