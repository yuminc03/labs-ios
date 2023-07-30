//
//  LazyNavigationVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/30.
//

import UIKit
import Combine

import ComposableArchitecture
import CombineCocoa
import SnapKit

final class LazyNavigationVC: TCABaseVC<LazyNavigation> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        return view
    }()
    
    private let loadOptionalCounterButton: UIButton = {
        let view = UIButton()
        view.setTitle("Load optional counter", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    init() {
        let store = Store(
            initialState: LazyNavigation.State(),
            reducer: LazyNavigation()
        )
        super.init(store: store)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isMovingToParent == false {
            viewStore.send(.setNavigation(isActive: false))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewStore.send(.onDisappear)
    }
    
    override func setup() {
        super.setup()
        setNavigationTitle(title: "Load then navigate")
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(loadOptionalCounterButton)
        stackView.addArrangedSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        
        loadOptionalCounterButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.setNavigation(isActive: true))
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.isActivityIndicatorHidden
            .assign(to: \.isHidden, on: activityIndicatorView)
            .store(in: &cancelBag)
        
        store.scope(
            state: \.optionalCounter,
            action: LazyNavigation.Action.optionalCounter
        )
        .ifLet(
            then: { [weak self] store in
                self?.navigationController?.pushViewController(
                    CounterVC(store: store)
                    ,
                    animated: true
                )
            },
            else: { [weak self] in
                guard let self else { return }
                navigationController?.popToViewController(self, animated: true)
            }
        )
        .store(in: &cancelBag)
    }
}
