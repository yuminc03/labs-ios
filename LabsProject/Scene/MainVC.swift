//
//  ViewController.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/04/21.
//

import UIKit
import Combine

import ComposableArchitecture
import SnapKit
import Then

final class MainVC: LabsVC {
    
    private let vm = MainVM()
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .clear
        $0.registerHeaderFooter(type: MainTableViewHeader.self)
        $0.registerCell(type: MainTableViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationController?.isNavigationBarHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func pushAnotherPage(vc: LabsVC) {
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = PractiseThenVC()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = WebVC()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = CookieWebVC()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = SegmentedVC()
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let counterVC = CounterVC(
                store: Store(initialState: Counter.State(), reducer: Counter())
            )
            navigationController?.pushViewController(counterVC, animated: true)
        case 5:
            let vc = TwoCountersVC(
                store: Store(
                    initialState: TwoCounters.State(),
                    reducer: TwoCounters()
                )
            )
            navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = BindingBasicsVC(
                store: Store(
                    initialState: BindingBasics.State(),
                    reducer: BindingBasics()
                )
            )
            navigationController?.pushViewController(vc, animated: true)
            
        case 7:
            let vc = BindingFormVC(
                store: Store(
                    initialState: BindingForm.State(),
                    reducer: BindingForm()
                )
            )
            navigationController?.pushViewController(vc, animated: true)
            
        case 8:
            let vc = ListOfStateVC(
                store: Store(
                    initialState:
                        CounterList.State(
                            counters: [
                                Counter.State(),
                                Counter.State(),
                                Counter.State(),
                            ]
                            
                        ),
                    reducer: CounterList()
                )
            )
            navigationController?.pushViewController(vc, animated: true)
            
        case 9:
            let vc = OptionalBasicsVC(
                store: Store(
                    initialState: OptionalBasics.State(),
                    reducer: OptionalBasics()
                )
            )
            navigationController?.pushViewController(vc, animated: true)
            
        case 10:
            let vc = SharedStateCounterVC(
                store: Store(
                    initialState: SharedState.State(),
                    reducer: SharedState()
                )
            )
            navigationController?.pushViewController(vc, animated: true)
            
        case 11:
            let vc = AlertAndConfirmationDialogVC(
                store: Store(
                    initialState: AlertAndConfirmationDialog.State(),
                    reducer: AlertAndConfirmationDialog()
                )
            )
            navigationController?.pushViewController(vc, animated: true)
        
        case 12:
            let vc = EffectsBasicsVC(
                store: Store(
                    initialState: EffectsBasics.State(),
                    reducer: EffectsBasics()
                )
            )
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
}

extension MainVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfRowsInSection(on: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(type: MainTableViewHeader.self)
        header.updateUI(title: vm.titleOfGroup(section: section))
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: MainTableViewCell.self, indexPath: indexPath)
        cell.updateUI(titleText: vm.titleOfPage(section: indexPath.section, index: indexPath.row))
        return cell
    }
}
