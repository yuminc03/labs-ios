//
//  HeartScrollView.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/25.
//

import UIKit

import FlexLayout
import PinLayout

final class HeartScrollView: UIScrollView {
  private let tableView: UITableView = {
    let v = UITableView()
    v.backgroundColor = .clear
    v.separatorStyle = .none
    return v
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
    addSubview(tableView)
  }
  
  private func setupConstraints() {
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.pin.top().horizontally().margin(pin.safeArea)
    tableView.flex.layout(mode: .adjustHeight)
  }
}
