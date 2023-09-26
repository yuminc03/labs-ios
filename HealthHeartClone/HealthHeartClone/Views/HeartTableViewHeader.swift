//
//  HeartTableViewHeader.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/25.
//

import UIKit

import FlexLayout
import PinLayout

final class HeartTableViewHeader: UITableViewHeaderFooterView {
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = .black
    v.font = .systemFont(ofSize: 20, weight: .medium)
    return v
  }()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupUI()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    titleLabel.flex.layout(mode: .adjustHeight)
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
  }
  
  private func setupUI() {
    contentView.backgroundColor = .clear
    contentView.addSubview(titleLabel)
  }
  
  private func setupConstraints() {
    titleLabel.flex.direction(.row).padding(5, 20)
  }
  
  func updateUI(title: String) {
    titleLabel.text = title
  }
}
