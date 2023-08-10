//
//  SharedStateCounterVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/16.
//

import UIKit

import CombineCocoa
import ComposableArchitecture
import SnapKit

final class SharedStateCounterVC: TCABaseVC<SharedState> {

        private let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Counter", "Profile"])
        return view
    }()
    
    private let counterView: SharedStateCounterView
    private let profileView: SharedStateProfileView

    override init(store: StoreOf<SharedState>) {
        self.counterView = SharedStateCounterView(
            store: store.scope(
                state: \.counter,
                action: SharedState.Action.counter
            )
        )

        self.profileView = SharedStateProfileView(
            store: store.scope(
                state: \.profile,
                action: SharedState.Action.profile
            )
        )
        super.init(store: store)
    }
    
    init() {
        let store = Store(initialState: SharedState.State()) {
            SharedState()
        }
        self.counterView = SharedStateCounterView(
            store: store.scope(
                state: \.counter,
                action: SharedState.Action.counter
            )
        )
        self.profileView = SharedStateProfileView(
            store: store.scope(
                state: \.profile,
                action: SharedState.Action.profile
            )
        )
        super.init(store: store)
    }
    
    override func setup() {
        super.setup()
        setNavigationTitle(title: "Shared State Demo")
        view.backgroundColor = .white
        view.addSubview(segmentedControl)
        view.addSubview(counterView)
        view.addSubview(profileView)
        
        counterView.delegate = self
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        counterView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    override func bind() {
        viewStore.publisher.currentTab
            .sink { [weak self] tab in
                self?.updateUI(selectedIndex: tab.rawValue)
            }
            .store(in: &cancelBag)
        
        segmentedControl.selectedSegmentIndexPublisher
            .sink { [weak self] selectedIndex in
                self?.viewStore.send(.selectTab(selectedIndex == 0 ? .counter : .profile))
            }
            .store(in: &cancelBag)
    }
    
    private func updateUI(selectedIndex: Int) {
        segmentedControl.selectedSegmentIndex = selectedIndex
        counterView.isHidden = selectedIndex == 1
        profileView.isHidden = selectedIndex == 0
    }
}

extension SharedStateCounterVC: SharedStateCounterViewAction {
    
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}
