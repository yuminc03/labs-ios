//
//  SharedStateCounterView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/16.
//

import UIKit

import ComposableArchitecture
import SnapKit

protocol SharedStateCounterViewAction: AnyObject {
    func presentAlert(alert: UIAlertController)
}

final class SharedStateCounterView: TCABaseView<SharedState.Counter> {
    
    weak var delegate: SharedStateCounterViewAction?
    
    private let containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()

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
    
    private let isPrimeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Is this prime?"
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10)
        let view = UIButton(configuration: config)
        view.backgroundColor = .white
        view.setTitleColor(.systemBlue, for: .normal)
        return view
    }()
    
    override func bind() {
        viewStore.publisher.alert
            .sink { [weak self] alert in
                guard let alert else { return }
                let alertVC = UIAlertController(
                    title: String(state: alert.title),
                    message: nil,
                    preferredStyle: .alert
                )
                alertVC.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self?.viewStore.send(.alertDismissed)
                })
                self?.delegate?.presentAlert(alert: alertVC)
            }
            .store(in: &cancelBag)
        
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
        
        viewStore.publisher.currentCount
            .sink { [weak self] count in
                self?.numberLabel.text = count.description
            }
            .store(in: &cancelBag)
        
        isPrimeButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapIsPrimeButton)
            }
            .store(in: &cancelBag)
    }
    
    override func setupUI() {
        backgroundColor = .white
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(stackView)
        containerStackView.addArrangedSubview(isPrimeButton)
        stackView.addArrangedSubview(minusButton)
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(plusButton)
        
        containerStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        minusButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
    }
}
