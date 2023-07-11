//
//  ListOfStateVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/10.
//

import UIKit
import Combine

import ComposableArchitecture
import SnapKit

struct CounterList: ReducerProtocol {
    struct State: Equatable {
        var counters: IdentifiedArrayOf<Counter.State> = []
    }
    
    enum Action: Equatable {
        case counter(id: Counter.State.ID, action: Counter.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
            .forEach(\.counters, action: /Action.counter) {
                Counter()
            }
    }
}

final class ListOfStateVC: TCABaseVC<CounterList> {
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.registerCell(type: UITableViewCell.self)
        return view
    }()

    override init(store: StoreOf<CounterList>) {
        super.init(store: store)
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setup() {
        super.setup()
        setNavigationTitle(title: "Lists")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        viewStore.publisher.counters
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancelBag)
    }
}

extension ListOfStateVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewStore.counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: UITableViewCell.self, indexPath: indexPath)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "\(viewStore.counters[indexPath.row].value)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let counter = viewStore.counters[indexPath.row]
        navigationController?.pushViewController(
            CounterVC(
                store: store.scope(
                    state: \.counters[indexPath.row],
                    action: {
                        .counter(id: counter.id, action: $0)
                    }
                )
            ),
            animated: true
        )
    }
}
