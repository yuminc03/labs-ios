//
//  ProgressView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/23.
//

import UIKit

import SnapKit

final class ProgressView: UIView {
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    private let stateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
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
        addSubview(loadingView)
        addSubview(stateLabel)
    }
    
    private func setupConstraints() {
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        stateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func updateIndicator(isLoading: Bool) {
        isLoading ? loadingView.startAnimating() : loadingView.stopAnimating()
    }
    
    func updateUI(numberFact: String?) {
        stateLabel.text = numberFact
    }
}
