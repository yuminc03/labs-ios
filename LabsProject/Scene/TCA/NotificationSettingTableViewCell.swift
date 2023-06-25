//
//  NotificationSettingTableViewCell.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/25.
//

import UIKit

import Combine
import CombineCocoa
import SnapKit

final class NotificationSettingTableViewCell: UITableViewCell {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 18)
        view.textAlignment = .center
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .systemGray
        return view
    }()
    
    private let switchButton: UISwitch = {
        let view = UISwitch()
        view.isOn = true
        return view
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        return view
    }()
    
    var cancelBag = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }
    
    func updateUI(data: (String, String)) {
        titleLabel.text = data.0
        descriptionLabel.text = data.1
    }
    
    func updateSwitch(index: Int) {
        switchButton.isHidden = index == 0 ? true : false
    }
    
    private func bind() {
        switchButton.isOnPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                self?.switchButton.isOn = isSelected
            }
            .store(in: &cancelBag)
    }
    
    private func setupUI() {
        backgroundColor = .white
        contentView.addSubview(stackView)
        contentView.addSubview(switchButton)
        contentView.addSubview(separatorView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        switchButton.snp.makeConstraints {
            $0.centerY.equalTo(stackView)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        separatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
    }
}
