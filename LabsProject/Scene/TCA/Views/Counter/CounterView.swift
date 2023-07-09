//
//  CounterView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/26.
//

import UIKit

import SnapKit

final class CounterView: TCABaseView<Counter> {
    
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
        
        viewStore.publisher.value
            .sink { [weak self] value in
                self?.numberLabel.text = value.description
            }
            .store(in: &cancelBag)
    }
    
    override func setupUI() {
        layer.cornerRadius = 10
        backgroundColor = .white
        addSubview(stackView)
        
        stackView.addArrangedSubview(minusButton)
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(plusButton)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.centerX.centerY.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
    }
}
