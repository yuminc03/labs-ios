//
//  SharedStateProfileView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/16.
//

import UIKit

import ComposableArchitecture
import SnapKit

final class SharedStateProfileView: TCABaseView<SharedState.Profile> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    private let currentCountLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    private let maxCountLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    private let minCountLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    private let totalCountLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    private let resetButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Reset"
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10)
        let view = UIButton(configuration: config)
        view.backgroundColor = .white
        view.setTitleColor(.systemBlue, for: .normal)
        return view
    }()
    
    override func setupUI() {
        backgroundColor = .white
        addSubview(stackView)
        [currentCountLabel, maxCountLabel, minCountLabel, totalCountLabel, resetButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func bind() {
        viewStore.publisher.currentCount
            .sink { [weak self] count in
                self?.currentCountLabel.text = "Current count: \(count)"
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.maxCount
            .sink { [weak self] maxCount in
                self?.maxCountLabel.text = "Max count: \(maxCount)"
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.minCount
            .sink { [weak self] minCount in
                self?.minCountLabel.text = "Min count: \(minCount)"
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.numberOfCounts
            .sink { [weak self] numberOfCounts in
                self?.totalCountLabel.text = "Total number of count events: \(numberOfCounts)"
            }
            .store(in: &cancelBag)
        
        resetButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapResetCounterButton)
            }
            .store(in: &cancelBag)
    }
}
