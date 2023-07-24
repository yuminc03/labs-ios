//
//  RefreshableTableViewCell.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/24.
//

import UIKit
import Combine

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
    
    let counterView = BasicCounterView()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        return view
    }()
    
    let progressView: ProgressView = {
        let view = ProgressView()
        view.backgroundColor = .white
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
        stackView.addArrangedSubview(counterView)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(progressView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
}

extension RefreshableTableViewCell {
    
    var minusButtonTapPublisher: AnyPublisher<Void, Never> {
        return counterView.minusButtonTapPublisher
    }
    
    var plusButtonTapPublisher: AnyPublisher<Void, Never> {
        return counterView.plusButtonTapPublisher
    }
}
