//
//  FocusDemoVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/19.
//

import UIKit

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
    }
    
    override func bind() {
        super.bind()
        
    }
}
