//
//  PractiseThenVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/04/23.
//

import UIKit

import SnapKit
import Then

final class PractiseThenVC: UIViewController {
    
    private let vm = PractiseThenVM()
    private let titleLabel = UILabel().then {
        $0.text = "More"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 32, weight: .bold)
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(MainTableViewCell.self, forCellReuseIdentifier: "mainCell")
        $0.register(PractiseThenTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        testUserDefaults()
    }
    
    private func testUserDefaults() {
        UserDefaults.standard.do {
            $0.setValue("practiseThenVC", forKey: "practiseThenVC")
            $0.synchronize()
            
            print("userDefaults member: \($0.value(forKey: "practiseThenVC") ?? "nil")")
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(titleLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension PractiseThenVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? PractiseThenTableViewHeader else { return UIView() }
        header.updateUI(headerTitle: vm.headerNames[section])
        return header
    }
}

extension PractiseThenVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.headerNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.cellNames[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return vm.headerHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "mainCell",
            for: indexPath
        ) as? MainTableViewCell, indexPath.row < vm.cellNames[indexPath.section].count else {
            return UITableViewCell()
        }
        cell.updateUI(titleText: vm.cellNames[indexPath.section][indexPath.row])
        return cell
    }
}
