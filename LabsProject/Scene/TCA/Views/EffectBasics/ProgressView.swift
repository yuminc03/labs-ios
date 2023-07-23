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
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        view.numberOfLines = 0
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
            $0.edges.equalToSuperview().inset(20)
        }
        
        stateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func updateIndicator(isLoading: Bool) {
        isLoading ? loadingView.startAnimating() : loadingView.stopAnimating()
    }
    
    func updateUI(numberFact: String?) {
        stateLabel.text = numberFact
    }
}
