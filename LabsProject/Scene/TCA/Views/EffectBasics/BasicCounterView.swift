//
//  BasicCounterView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/24.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class BasicCounterView: UIView {
    
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
    
    let numberLabel: UILabel = {
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
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        addSubview(counterStackView)
        counterStackView.addArrangedSubview(minusButton)
        counterStackView.addArrangedSubview(numberLabel)
        counterStackView.addArrangedSubview(plusButton)
    }
    
    private func setupConstraints() {
        counterStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
    }
}

extension BasicCounterView {
    
    var minusButtonTapPublisher: AnyPublisher<Void, Never> {
        return minusButton.tapPublisher
    }
    
    var plusButtonTapPublisher: AnyPublisher<Void, Never> {
        return plusButton.tapPublisher
    }
}
