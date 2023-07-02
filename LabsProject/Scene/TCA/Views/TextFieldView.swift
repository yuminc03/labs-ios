//
//  TextFieldView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/02.
//

import UIKit

import SnapKit

final class TextFieldView: BaseView<BindingForm> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        return view
    }()

    private let textField: UITextField = {
        let view = UITextField()
        view.placeholder = "Type here"
        view.textColor = labsColor(.gray_EAEAEA)
        view.font = .systemFont(ofSize: 20)
        return view
    }()
    
    private let textLabel: UILabel = {
        let view = UILabel()
        view.textColor = labsColor(.gray_2F2F2F)
        view.font = .systemFont(ofSize: 16)
        return view
    }()

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
