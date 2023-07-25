//
//  RefreshableTableViewCell.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/24.
//

import UIKit
import Combine

import ComposableArchitecture
import CombineCocoa
import SnapKit

final class RefreshableTableViewCell: UITableViewCell {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }
    
    private func setupUI() {
        backgroundColor = .white
        selectionStyle = .none
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func bind(store: StoreOf<Counter>) {
        let counter = CounterView(store: store)
        stackView.addArrangedSubview(counter)
        stackView.addArrangedSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
}
