//
//  ContainButtonRoundedView.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/29.
//

import UIKit

import FlexLayout
import PinLayout

final class ContainButtonRoundedView: UIView {
  private let containerView: UIView = {
    let v = UIView()
    v.backgroundColor = .clear
    return v
  }()
  
  private let roundedView: UIView = {
    let v = UIView()
    v.backgroundColor = .white
    v.layer.cornerRadius = 10
    return v
  }()
  
  private let imageView: UIImageView = {
    let v = UIImageView()
    v.tintColor = .systemRed
    return v
  }()
  
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
    v.font = .systemFont(ofSize: 16)
    v.numberOfLines = 0
    return v
  }()
  
  private let settingButton: UIButton = {
    let v = UIButton()
    v.setTitle("설정", for: .normal)
    v.setTitleColor(.white, for: .normal)
    v.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    v.backgroundColor = .systemBlue
    v.layer.cornerRadius = 10
    return v
  }()
  
  init() {
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.flex.layout(mode: .adjustHeight)
    containerView.pin.margin(pin.safeArea)
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
      $0.addItem(roundedView).direction(.column).paddingTop(40).define {
        $0.addItem().alignItems(.center).define {
          $0.addItem(imageView).width(100).aspectRatio(1)
        }
        $0.addItem().padding(20, 20).define {
          $0.addItem(titleLabel)
          $0.addItem(contentsLabel).marginTop(10)
          $0.addItem(settingButton).height(48).marginTop(20)
        }
      }
    }
  }
  
  func updateUI(data: LearnMoreInfo.Setting) {
    imageView.image = UIImage(systemName: data.imageName)
    titleLabel.text = data.title
    contentsLabel.text = data.contents
  }
}
