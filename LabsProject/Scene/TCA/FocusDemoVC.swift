//
//  FocusDemoVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/19.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

final class FocusDemoVC: TCABaseVC<FocusDemo> {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private let userNameTextField: UITextField = {
        let view = UITextField()
        view.layer.borderColor = labsColor(.gray_EAEAEA)?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.placeholder = "Username"
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let view = UITextField()
        view.layer.borderColor = labsColor(.gray_EAEAEA)?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.placeholder = "Password"
        view.isSecureTextEntry = true
        return view
    }()
    
    private let signInButton: UIButton = {
        let view = UIButton()
        view.setTitle("Sign In", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 16)
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemBlue
        return view
    }()

    override func setup() {
        super.setup()
        view.backgroundColor = .systemGray6
        view.addSubview(containerView)
        setNavigationTitle(title: "Focus demo")
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        [userNameTextField, passwordTextField, signInButton].forEach { subview in
            stackView.addArrangedSubview(subview)
        }
        
        userNameTextField.snp.makeConstraints {
            $0.height.equalTo(36)
        }

        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(36)
        }
    }
    
    override func bind() {
        super.bind()
        userNameTextField.textPublisher
            .compactMap { $0 }
            .print()
            .sink { [weak self] in
                self?.viewStore.send(.didChangeUserName($0))
            }
            .store(in: &cancelBag)
        
        passwordTextField.textPublisher
            .compactMap { $0 }
            .print()
            .sink { [weak self] in
                self?.viewStore.send(.didChangePassword($0))
            }
            .store(in: &cancelBag)
        
        signInButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapSignInButton)
            }
            .store(in: &cancelBag)
    }
}
