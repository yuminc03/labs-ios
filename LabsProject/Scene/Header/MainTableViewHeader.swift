//
//  MainTableViewHeader.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/23.
//

import UIKit

import SnapKit

final class MainTableViewHeader: UITableViewHeaderFooterView {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 16)
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }
    
    private func setupUI() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func updateUI(title: String) {
        titleLabel.text = title
    }
}
