//
//  PractiseThenTableViewHeader.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/04/23.
//

import UIKit

import SnapKit
import Then

final class PractiseThenTableViewHeader: UITableViewHeaderFooterView {
    
    private let titleLabel = UILabel().then {
        $0.textColor = .systemGray3
        $0.font = .systemFont(ofSize: 14)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("do not use storyboard")
    }
    
    private func setupUI() {
        backgroundView?.backgroundColor = .white
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func updateUI(headerTitle: String) {
        titleLabel.text = headerTitle
    }
}
