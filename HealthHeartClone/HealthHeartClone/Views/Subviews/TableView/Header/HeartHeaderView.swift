//
//  HeartHeaderView.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/26.
//

import UIKit

import FlexLayout
import PinLayout

/// 심장 TableHeaderView
final class HeartHeaderView: UIView {
  private let containerView: UIView = {
    let v = UIView()
    v.backgroundColor = .clear
    return v
  }()
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = .black
    v.font = .systemFont(ofSize: 36, weight: .bold)
    return v
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.all().margin(containerView.pin.safeArea)
    containerView.flex.layout(mode: .adjustHeight)
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
  }
  
  private func setupUI() {
    backgroundColor = .clear
    addSubview(containerView)
  }
  
  private func setupConstraints() {
    containerView.flex.direction(.row).padding(10, 20).define {
      $0.addItem(titleLabel)
    }
  }
  
  func update(title: String) {
    titleLabel.text = title
  }
}
