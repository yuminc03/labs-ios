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
    containerView.pin.top().horizontally()
    containerView.flex.layout(mode: .adjustHeight)
    contentSize = containerView.frame.size
    // tableView.contentSize가 업데이트되는 시점에 레이아웃 다시 그려주기
    tableView.flex.markDirty()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
  }
  
  private func setupUI() {
    backgroundColor = .clear
    addSubview(containerView)
  }
  
  private func setupConstraints() {
    containerView.flex.direction(.column).define {
      $0.addItem(tableView)
      $0.addItem(learnMoreInHealthAppView).marginTop(10)
      $0.addItem(aboutTheHeartView).marginTop(40)
    }
  }
  
  func updateUI(learnMoreInfo: LearnMoreInfo, aboutTheHeart: AboutHeart) {
    learnMoreInHealthAppView.updateUI(data: learnMoreInfo)
    aboutTheHeartView.updateUI(data: aboutTheHeart)
  }
}
