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
    
    private let datas = [
        "Practise Then library",
        "WebView Test",
        "WebView Cookie Test",
        "Todos",
        "TCA - Counter",
        "TCA - Two Counters",
        "TCA - BindingBasicsView",
        "TCA - BindingFormView",
        "TCA - ListOfStateVC"
    ]
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .clear
        $0.register(MainTableViewCell.self, forCellReuseIdentifier: "mainCell")
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
            
        default:
            break
        }
    }
}

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.updateUI(titleText: datas[indexPath.row])
        return cell
    }
}
