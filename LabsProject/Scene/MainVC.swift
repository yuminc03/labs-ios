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
            TimersVC()
        ],
        [
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
            EagerNavigationVC(),
            LazyNavigationVC()
        ]
    ]
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.registerHeaderFooter(type: MainTableViewHeader.self)
        view.registerCell(type: MainTableViewCell.self)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
