//
//  NotificationSettingVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/25.
//

import UIKit

import ComposableArchitecture

import CombineCocoa
import SnapKit

struct NotificationSettingReducer: ReducerProtocol {
    
    struct State: Equatable {
        var isSelected: Bool = true
    }
    
    enum Action: Equatable {
        case switchSelected(Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        
        switch action {
        case .switchSelected(let isSelected):
            state.isSelected = isSelected
            print("isSelected: \(isSelected)")
            return .none
        }
    }
}
/// 알림 설정
final class NotificationSettingVC: LabsVC {
    
    let notificationTexts = [
        ("예약/진료 알림", "예약, 진료 관련 알림이 자동 전송됩니다"),
        ("친사 알림", "친사 선생님과 주고 받는 글 알림"),
        ("배송 알림", "조제약 배송 관련 알림"),
        ("마케팅 알림", "상품 할인, 이벤트, 광고 등 다양한 혜택 알림")
    ]
    private let navigationBar = NavigationBarView(title: "알림 설정")

    private let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.registerCell(type: NotificationSettingTableViewCell.self)
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
    }
    
    private func setupUI() {
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(109)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension NotificationSettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(
            type: NotificationSettingTableViewCell.self,
            indexPath: indexPath
        )
        cell.updateUI(data: notificationTexts[indexPath.row])
        cell.updateSwitch(index: indexPath.row)
        return cell
    }
}
