//
//  HeartTableViewHeader.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/25.
//

import UIKit

import FlexLayout
import PinLayout

/// 심박수 Section Header (오늘, 최근 7일 ..)
final class HeartTableViewHeader: UITableViewHeaderFooterView {
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = .black
    v.font = .systemFont(ofSize: 24, weight: .bold)
    v.sizeToFit()
    return v
  }()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupUI()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.flex.layout(mode: .adjustHeight)
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.flex.width(size.width)
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
  }
  
  private func setupUI() {
    contentView.backgroundColor = .clear
  }
  
  private func setupConstraints() {
    contentView.flex.direction(.row).paddingBottom(5).define {
      $0.addItem(titleLabel)
    }
  }
  
  func updateUI(title: String) {
    titleLabel.text = title
  }
}
