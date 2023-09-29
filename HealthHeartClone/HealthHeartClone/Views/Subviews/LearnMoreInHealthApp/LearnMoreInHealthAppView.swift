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
  
  /// 심방세동 기록
  private let atrialFibrillationView = ContainButtonRoundedView()
  /// 심전도 검사
  private let cardiographyView = ContainButtonRoundedView()
  private var roundedViews = [ContainButtonRoundedView]()
  
  init() {
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.margin(pin.safeArea)
    containerView.flex.layout(mode: .adjustHeight)
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    containerView.flex.width(size.width)
    containerView.flex.layout(mode: .adjustHeight)
    return containerView.frame.size
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storboard.")
  }
  
  private func setupUI() {
    backgroundColor = .clear
    addSubview(containerView)
    roundedViews.append(atrialFibrillationView)
    roundedViews.append(cardiographyView)
  }
  
  private func setupConstraints() {
    containerView.flex.direction(.column).padding(0, 20).define {
      $0.addItem(titleLabel)
      $0.addItem(atrialFibrillationView).marginTop(10)
      $0.addItem(cardiographyView).marginTop(10)
    }
  }
  
  func updateUI(data: LearnMoreInfo) {
    titleLabel.text = data.title
    for i in 0 ..< data.settings.count {
      roundedViews[i].updateUI(data: data.settings[i])
    }
  }
}
