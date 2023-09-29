//
//  AboutTheHeartView.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/29.
//

import UIKit

import FlexLayout
import PinLayout

/// 심장에 관하여 View
final class AboutTheHeartView: UIView {
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
  
  /// 유산소 피트니스가 낮은 경우
  private let meansWhenLowFitnessView = RoundedRectangleView()
  /// 유산소 피트니스에 관하여
  private let aboutFitnessView = RoundedRectangleView()
  /// 심방세동 부담에 관하여
  private let aboutBurdenOfFibrillation = RoundedRectangleView()
  
  private let roundedViews: [RoundedRectangleView]
  
  init() {
    self.roundedViews = [meansWhenLowFitnessView, aboutFitnessView, aboutBurdenOfFibrillation]
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.margin(pin.safeArea)
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
    containerView.flex.padding(0, 20).define {
      $0.addItem(titleLabel)
      $0.addItem(meansWhenLowFitnessView).marginTop(10)
      $0.addItem(aboutFitnessView).marginTop(10)
      $0.addItem(aboutBurdenOfFibrillation).marginTop(10)
    }
  }
  
  func updateUI(data: AboutHeart) {
    titleLabel.text = data.title
    for i in 0 ..< data.articles.count {
      roundedViews[i].updateUI(data: data.articles[i])
    }
  }
}
