//
//  NumberFactView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/23.
//

import UIKit

import SnapKit

final class NumberFactView: UIView {
    
    private let stateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
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
        addSubview(stateLabel)
    }
    
    private func setupConstraints() {
        stateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func updateUI(numberFact: String?) {
        stateLabel.text = numberFact
    }
}
