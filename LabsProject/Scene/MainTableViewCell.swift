//
//  MainTableViewCell.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/04/22.
//

import UIKit

import SnapKit

final class MainTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("do not use storyboard")
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func updateUI(titleText: String) {
        titleLabel.text = titleText
    }
}
