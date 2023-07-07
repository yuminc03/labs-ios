//
//  TodoListCell.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/07.
//

import UIKit

import SnapKit

final class TodoListCell: UICollectionViewCell {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 40
        return view
    }()
    
    private let imageView = UIImageView()
    
    private let numberLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 30, weight: .medium)
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 3
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(numberLabel)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
