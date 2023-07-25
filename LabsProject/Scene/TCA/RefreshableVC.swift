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
        var counter = Counter.State()
        var fact: String?
    }
    
    enum Action {
        case counter(Counter.Action)
        case didTapCancelButton
        case factResponse(TaskResult<String>)
        case refresh
    }
    
    @Dependency(\.factClient) var factClient
    private enum CancelID {
        case factRequest
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.counter, action: /Action.counter) {
            Counter()
        }
        Reduce { state, action in
            switch action {
            case .didTapCancelButton:
                return .cancel(id: CancelID.factRequest)
                
            case let .factResponse(.success(fact)):
                state.fact = fact
                return .none
                
            case .factResponse(.failure):
                return .none
                
            case .refresh:
                state.fact = nil
                return .run { [number = state.counter.value] send in
                    await send(
                        .factResponse(TaskResult { try await factClient.fetch(number) }),
                        animation: .default
                    )
                }
                .cancellable(id: CancelID.factRequest)
                
            default:
                return .none
            }
        }
    }
}

final class RefreshableVC: TCABaseVC<Refreshable> {
    
    private let refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.endRefreshing()
        return view
    }()

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
        tableView.refreshControl = refreshControl
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension RefreshableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: RefreshableTableViewCell.self, indexPath: indexPath)
        cell.bind(store: store.scope(state: \.counter, action: Refreshable.Action.counter))
        viewStore.publisher.fact
            .assign(to: \.text, on: cell.textContainerView.titleLabel)
            .store(in: &cancelBag)
        
        refreshControl.isRefreshingPublisher
            .sink { [weak self] _ in
                Task {
                    await self?.viewStore.send(.refresh).finish()
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancelBag)
        return cell
    }
}
