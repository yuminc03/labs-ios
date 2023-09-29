//
//  RoundedRectangleView.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/29.
//

import UIKit

import FlexLayout
import PinLayout

final class RoundedRectangleView: UIView {
  private let containerView: UIView = {
    let v = UIView()
    v.backgroundColor = .clear
    return v
  }()
  
  private let roundedView: UIView = {
    let v = UIView()
    v.backgroundColor = .white
    v.layer.cornerRadius = 10
    v.layer.masksToBounds = true
    return v
  }()
  
  private let imageView = UIImageView()
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = .black
    v.font = .systemFont(ofSize: 20, weight: .semibold)
    v.numberOfLines = 0
    return v
  }()
  
  private let contentsLabel: UILabel = {
    let v = UILabel()
    v.textColor = .black
    v.font = .systemFont(ofSize: 16, weight: .medium)
    v.numberOfLines = 0
    return v
  }()
  
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
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
  }
  
  private func setupUI() {
    backgroundColor = .clear
    addSubview(containerView)
  }
  
  private func setupConstraints() {
    containerView.flex.define {
      $0.addItem(roundedView).direction(.column).define {
        $0.addItem(imageView).height(200)
        $0.addItem().padding(10, 20).define {
          $0.addItem(titleLabel)
          $0.addItem(contentsLabel).marginTop(10)
        }
      }
    }
  }
  
  func updateUI(data: AboutHeart.Article) {
    imageView.image = UIImage(named: data.imageName)
    titleLabel.text = data.title
    contentsLabel.text = data.contents
  }
}
