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
    v.isScrollEnabled = false
    v.registerCell(type: HeartTableViewCell.self)
    v.registerCell(type: MaximumOxygenCell.self)
    v.registerCell(type: UnusableDataCell.self)
    v.registerHeaderFooter(type: HeartTableViewHeader.self)
    return v
  }()
  
  private let learnMoreInHealthAppView = LearnMoreInHealthAppView()
  private let aboutTheHeartView = AboutTheHeartView()
  
  init() {
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.margin(pin.safeArea)
    containerView.flex.layout(mode: .adjustHeight)
    contentSize = containerView.frame.size
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
      $0.addItem(learnMoreInHealthAppView).marginTop(40)
      $0.addItem(aboutTheHeartView).marginTop(40)
    }
  }
  
  func updateUI(learnMoreInfo: LearnMoreInfo, aboutTheHeart: AboutHeart) {
    learnMoreInHealthAppView.updateUI(data: learnMoreInfo)
    aboutTheHeartView.updateUI(data: aboutTheHeart)
  }
}
