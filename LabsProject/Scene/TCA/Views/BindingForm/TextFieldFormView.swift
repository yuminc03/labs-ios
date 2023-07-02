//
//  TextiFieldFormView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/03.
//

import UIKit
import Combine

import SnapKit

final class TextFieldFormView: BaseView<BindingForm> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        return view
    }()

    private let textField: UITextField = {
        let view = UITextField()
        view.placeholder = "Type here"
        view.textColor = labsColor(.gray_2F2F2F)
        return view
    }()
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.textColor = labsColor(.gray_2F2F2F)
        return view
    }()
    
    override func bind() {
        super.bind()
        
        textField.textPublisher
            .compactMap { $0 }
            .sink { [weak self] text in
                self?.viewStore.send(.didChangeText(text))
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.text
            .sink { [weak self] text in
                self?.textField.text = text.description
                self?.textLabel.text = text.description
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.isToggleOn
            .sink { [weak self] isToggleOn in
                self?.textField.isEnabled = isToggleOn == false
            }
            .store(in: &cancelBag)
    }
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = .white
        addSubview(stackView)
        
        [textField, textLabel].forEach { subview in
            stackView.addArrangedSubview(subview)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
