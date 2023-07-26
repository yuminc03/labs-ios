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
            .sink { fact in
                cell.textContainerView.titleLabel.text = fact
                cell.textContainerView.cancelButton.isHidden = fact != nil
            }
            .store(in: &cancelBag)
        
        refreshControl.isRefreshingPublisher
            .sink { [weak self] isRefreshing in
                Task {
                    await self?.viewStore.send(.refresh).finish()
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancelBag)
        
        cell.textContainerView.cancelButtonTapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapCancelButton)
            }
            .store(in: &cancelBag)
        return cell
    }
}
