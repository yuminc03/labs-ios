//
//  NavigationDemoVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/31.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

final class NavigationDemoVC: TCABaseVC<NavigationDemo> {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Root"
        view.font = .systemFont(ofSize: 30, weight: .bold)
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.registerCell(type: MainTableViewCell.self)
        return view
    }()

    init() {
        let store = Store(
            initialState: NavigationDemo.State(
                path: StackState([
                    .screenA(ScreenA.State())
                ])
            ),
            reducer: NavigationDemo())
        super.init(store: store)
    }
    
    override func setup() {
        super.setup()
        setNavigationTitle(title: "Navigation Stack")
        view.backgroundColor = .systemGray6
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstriants()
    }
    
    override func bind() {
        super.bind()
    }
    
    private func setupConstriants() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension NavigationDemoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: MainTableViewCell.self, indexPath: indexPath)
        if indexPath.section == 0 {
            cell.updateUI(titleText: viewStore.rowTitles[indexPath.row])
        } else {
            cell.updateUI(titleText: viewStore.rowTitles.last ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            viewStore.send(.didTapGoToABCButton)
        }
    }
}
