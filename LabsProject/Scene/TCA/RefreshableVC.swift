//
//  RefreshableVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/24.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

struct Refreshable: ReducerProtocol {
    
    struct State: Equatable {
        var number = 0
        var fact: String?
    }
    
    enum Action {
        case didTapCancelButton
        case didTapDecrementButton
        case didTapIncrementButton
        case factResponse(TaskResult<String>)
        case refresh
    }
    
    @Dependency(\.factClient) var factClient
    private enum CancelID {
        case factRequest
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapCancelButton:
            return .cancel(id: CancelID.factRequest)
            
        case .didTapDecrementButton:
            state.number -= 1
            return .none
            
        case .didTapIncrementButton:
            state.number += 1
            return .none
            
        case let .factResponse(.success(fact)):
            state.fact = fact
            return .none
            
        case .factResponse(.failure):
            return .none
            
        case .refresh:
            state.fact = nil
            return .run { [number = state.number] send in
                await send(
                    .factResponse(TaskResult { try await factClient.fetch(number) }),
                    animation: .default
                )
            }
            .cancellable(id: CancelID.factRequest)
        }
    }
}

final class RefreshableVC: TCABaseVC<Refreshable> {
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.backgroundColor = .clear
        view.registerCell(type: RefreshableTableViewCell.self)
        view.separatorStyle = .none
        return view
    }()
    
    init() {
        let store = Store(
            initialState: Refreshable.State(),
            reducer: Refreshable()
        )
        super.init(store: store)
    }
    
    override func setup() {
        super.setup()
        setNavigationTitle(title: "Refreshable")
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func bindCell(counterView: BasicCounterView, separatorView: UIView, progressView: ProgressView) {
        viewStore.publisher.number
            .sink { number in
                counterView.numberLabel.text = number.description
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.fact
            .sink { fact in
                progressView.isHidden = fact == nil
                separatorView.isHidden = fact == nil
                progressView.updateUI(numberFact: fact)
            }
            .store(in: &cancelBag)
        
        counterView.minusButtonTapPublisher
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapDecrementButton)
            }
            .store(in: &cancelBag)
        
        counterView.plusButtonTapPublisher
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapIncrementButton)
            }
            .store(in: &cancelBag)
    }
}

extension RefreshableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: RefreshableTableViewCell.self, indexPath: indexPath)
        bindCell(
            counterView: cell.counterView,
            separatorView: cell.separatorView,
            progressView: cell.progressView
        )
        return cell
    }
}
