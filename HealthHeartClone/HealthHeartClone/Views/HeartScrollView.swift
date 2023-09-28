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
  private let containerView: UIView = {
    let v = UIView()
    v.backgroundColor = .clear
    return v
  }()
  
  let tableView: UITableView = {
    let v = UITableView(frame: .zero, style: .insetGrouped)
    v.backgroundColor = .clear
    v.separatorStyle = .none
    v.registerCell(type: HeartTableViewCell.self)
    v.registerCell(type: MaximumOxygenCell.self)
    v.registerCell(type: UnusableDataCell.self)
    v.registerHeaderFooter(type: HeartTableViewHeader.self)
    return v
  }()
  
  init() {
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.all().margin(pin.safeArea)
    containerView.flex.layout(mode: .adjustHeight)
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
  }
  
  private func setupUI() {
    backgroundColor = .clear
    addSubview(containerView)
    let header = HeartHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
    header.update(title: "심장")
    tableView.tableHeaderView = header
  }
  
  private func setupConstraints() {
    containerView.flex.direction(.column).define {
      $0.addItem(tableView)
    }
  }
}
