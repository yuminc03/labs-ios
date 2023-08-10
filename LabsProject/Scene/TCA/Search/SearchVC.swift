//
//  SearchVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/08/07.
//

import UIKit
import Combine

import ComposableArchitecture
import CombineCocoa
import SnapKit

final class SearchVC: TCABaseVC<Search> {
    
    private let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 20
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "Search"
        v.textColor = .black
        v.font = .systemFont(ofSize: 30, weight: .semibold)
        return v
    }()
    
    private let contentLabel: UILabel = {
        let v = UILabel()
        v.text = "This application demonstrates live-searching with the Composable Architecture. As you type the events are debounced for 300ms, and when you stop typing an API request is made to load locations. Then tapping on a location will load weather."
        v.textColor = .black
        v.numberOfLines = 0
        return v
    }()
    
    private let innerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "magnifyingglass")
        view.tintColor = .black
        return view
    }()

    private let textField: UITextField = {
        let view = UITextField()
        view.layer.borderWidth = 1
        view.layer.borderColor = labsColor(.gray_EAEAEA)?.cgColor
        view.layer.cornerRadius = 10
        view.placeholder = "New York, San Francisco, ..."
        return view
    }()
    
    private let tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .insetGrouped)
        v.backgroundColor = .clear
        v.separatorStyle = .none
        v.registerCell(type: MainTableViewCell.self)
        return v
    }()
    
    init() {
        let store = Store(initialState: Search.State()) {
            Search()
        }
        super.init(store: store)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            do {
                try await Task.sleep(nanoseconds: NSEC_PER_SEC / 3)
                await viewStore.send(.didChangeSearchQueryDebounced).finish()
                print("Send didChangeSearchQueryDebounced")
            } catch {
                
            }
        }
    }
    
    override func setup() {
        super.setup()
        setNavigationTitle(title: "Search")
        view.addSubview(stackView)
        tableView.dataSource = self
        stackView.addArrangedSubviews([
            titleLabel, contentLabel,
            innerStackView, tableView
        ])
        innerStackView.addArrangedSubviews([
            imageView, textField
        ])
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewStore.publisher.results
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancelBag)
        
        textField.textPublisher
            .compactMap { $0 }
            .sink { [weak self] in
                self?.viewStore.send(.didChangeSearchQuery($0))
            }
            .store(in: &cancelBag)
        
        tableView.didSelectRowPublisher
            .sink { [weak self] indexPath in
                guard let location = self?.viewStore.results[indexPath.row] else { return }
                self?.viewStore.send(.didTapSearchResult(location))
            }
            .store(in: &cancelBag)
    }
}

extension SearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewStore.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: MainTableViewCell.self, indexPath: indexPath)
        cell.updateUI(titleText: viewStore.results[indexPath.row].name)
        return cell
    }
}
