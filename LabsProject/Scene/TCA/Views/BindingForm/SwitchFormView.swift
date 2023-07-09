//
//  SwitchFormView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/03.
//

import UIKit
import Combine

import SnapKit

final class SwitchFormView: TCABaseView<BindingForm> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        return view
    }()
    
    private let textLabel: UILabel = {
        let view = UILabel()
        view.textColor = labsColor(.gray_2F2F2F)
        view.text = "Disable other controls"
        return view
    }()
    
    private let uiSwitch: UISwitch = {
        let view = UISwitch()
        return view
    }()

    override func bind() {
        super.bind()
        
        uiSwitch.isOnPublisher
            .sink { [weak self] isOn in
                self?.viewStore.send(.didChangeToggle(isOn: isOn))
            }
            .store(in: &cancelBag)
    }
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = .white
        addSubview(stackView)
        
        [textLabel, uiSwitch].forEach { subview in
            stackView.addArrangedSubview(subview)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
