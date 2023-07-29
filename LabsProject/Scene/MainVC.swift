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
    
    private let viewControllers = [
        [
            PractiseThenVC(),
            WebVC(),
            CookieWebVC()
        ],
        [
            SegmentedVC()
        ],
        [
            CounterVC(
                store: Store(initialState: Counter.State(), reducer: Counter())
            ),
            TwoCountersVC(
                store: Store(
                    initialState: TwoCounters.State(),
                    reducer: TwoCounters()
                )
            ),
            BindingBasicsVC(
                store: Store(
                    initialState: BindingBasics.State(),
                    reducer: BindingBasics()
                )
            ),
            BindingFormVC(
                store: Store(
                    initialState: BindingForm.State(),
                    reducer: BindingForm()
                )
            ),
            ListOfStateVC(
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
            ),
            OptionalBasicsVC(
                store: Store(
                    initialState: OptionalBasics.State(),
                    reducer: OptionalBasics()
                )
            ),
            SharedStateCounterVC(
                store: Store(
                    initialState: SharedState.State(),
                    reducer: SharedState()
                )
            ),
            AlertAndConfirmationDialogVC(
                store: Store(
                    initialState: AlertAndConfirmationDialog.State(),
                    reducer: AlertAndConfirmationDialog()
                )
            )
        ],
        [
            EffectsBasicsVC(
                store: Store(
                    initialState: EffectsBasics.State(),
                    reducer: EffectsBasics()
                )
            ),
            EffectsCancellationVC(
                store: Store(
                    initialState: EffectsCancellation.State(),
                    reducer: EffectsCancellation()
                )
            ),
            EffectsLongLivingVC(
                store: Store(
                        initialState: EffectsLongLiving.State(),
                        reducer: EffectsLongLiving()
                )
            ),
            RefreshableVC(),
            TimersVC(),
            EagerNavigationVC()
        ]
    ]
    
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
            $0.edges.equalToSuperview()
        }
    }
    
    private func navigateChildVC(section: Int, index: Int) {
        guard let section = viewControllers[safe: section],
              let vc = section[safe: index] else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateChildVC(section: indexPath.section, index: indexPath.row)
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
