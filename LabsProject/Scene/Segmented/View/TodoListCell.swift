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
        view.spacing = 30
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .systemGray
        return view
    }()
    
    private let numberLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 42, weight: .medium)
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
        contentView.layer.borderWidth = 8
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(numberLabel)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(80)
        }
    }
    
    func updateUI(data: TodosDTO) {
        imageView.image = UIImage(systemName: "person.fill.questionmark")
        numberLabel.text = data.id.description
    }
}
