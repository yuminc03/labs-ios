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
    
    let textContainerView = TextContainerView()
    
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
        stackView.addArrangedSubview(textContainerView)
        
        counter.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
}

final class TextContainerView: UIView {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        return view
    }()
    
    let cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle("Cancel", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.isHidden = true
        return view
    }()

    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .bold)
        view.numberOfLines = 0
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension TextContainerView {
    var cancelButtonTapPublisher: AnyPublisher<Void, Never> {
        return cancelButton.tapPublisher
    }
}
