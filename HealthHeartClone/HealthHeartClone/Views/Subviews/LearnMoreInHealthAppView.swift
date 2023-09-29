//
//  LearnMoreInHealthAppView.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/29.
//

import UIKit

import FlexLayout
import PinLayout

/// 건강 앱에서 더 알아보기 View
final class LearnMoreInHealthAppView: UIView {
  private let containerView: UIView = {
    let v = UIView()
    v.backgroundColor = .clear
    return v
  }()
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = .black
    v.font = .systemFont(ofSize: 24, weight: .bold)
    return v
  }()
  
  init() {
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storboard.")
  }
  
  private func setupUI() {
    
  }
  
  private func setupConstraints() {
    
  }
}
