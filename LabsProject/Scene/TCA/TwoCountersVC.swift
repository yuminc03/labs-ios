//
//  TwoCountersVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/26.
//

import UIKit

import ComposableArchitecture
import SnapKit

final class TwoCountersVC: LabsVC {
    
    private let navigationBar = NavigationBarView(title: "TwoCountersVC")
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bind()
    }
    
    private func bind() {
        navigationBar.backButton.tapPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        view.addSubview(navigationBar)
        view.addSubview(stackView)
        
        [CounterView(
            store: Store(initialState: Counter.State(), reducer: Counter())
        ), CounterView(
            store: Store(initialState: Counter.State(), reducer: Counter())
        )].forEach { subview in
            stackView.addArrangedSubview(subview)
        }
    }
    
    private func setupConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(109)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.bottom.lessThanOrEqualToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
