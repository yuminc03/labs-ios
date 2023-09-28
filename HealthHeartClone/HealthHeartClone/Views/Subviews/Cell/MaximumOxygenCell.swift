//
//  BelowAverageCell.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/28.
//

import UIKit

import FlexLayout
import PinLayout

/// 최대 산소 섭취량 Cell
final class MaximumOxygenCell: UITableViewCell {
  private let containerView: UIView = {
    let v = UIView()
    v.backgroundColor = .white
    v.layer.cornerRadius = 10
    return v
  }()
  
  private let heartImageView: UIImageView = {
    let v = UIImageView()
    v.image = UIImage(systemName: "heart.fill")
    v.tintColor = .systemPink
    return v
  }()
  
  private let fitnessLabel: UILabel = {
    let v = UILabel()
    v.textColor = .systemPink
    v.font = .systemFont(ofSize: 16, weight: .bold)
    return v
  }()
  
  private let timeLabel: UILabel = {
    let v = UILabel()
    v.textColor = .lightGray
    v.font = .systemFont(ofSize: 14, weight: .medium)
    return v
  }()
  
  private let rightArrowImage: UIImageView = {
    let v = UIImageView()
    v.image = UIImage(systemName: "chevron.right")
    v.tintColor = .lightGray
    return v
  }()
  
  private let maxOxygenIntakeLabel: UILabel = {
    let v = UILabel()
    v.textColor = .black
    v.font = .systemFont(ofSize: 20, weight: .bold)
    v.sizeToFit()
    return v
  }()
  
  private let maxOxygenIntakeValueLabel: UILabel = {
    let v = UILabel()
    v.textColor = .lightGray
    v.font = .systemFont(ofSize: 14, weight: .bold)
    v.sizeToFit()
    return v
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
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
  
  private func setupUI() {
    backgroundColor = .clear
    selectionStyle = .none
  }
  
  private func setupConstraints() {
    contentView.flex.padding(5, 0).define {
      $0.addItem(containerView).direction(.column).padding(10, 10).define {
        $0.addItem().direction(.row).justifyContent(.spaceBetween).define {
          $0.addItem().direction(.row).alignItems(.center).define {
            $0.addItem(heartImageView).width(20).aspectRatio(of: heartImageView)
            $0.addItem(fitnessLabel).marginLeft(5)
          }
          $0.addItem().direction(.row).alignItems(.center).define {
            $0.addItem(timeLabel)
            $0.addItem(rightArrowImage).width(10).aspectRatio(of: rightArrowImage).marginLeft(10)
          }
        }
        $0.addItem().direction(.column).marginTop(20).define {
          $0.addItem(maxOxygenIntakeLabel)
          $0.addItem(maxOxygenIntakeValueLabel)
        }
      }
    }
  }
  
  func updateUI(data: HeartBeat.Heart) {
    fitnessLabel.text = data.title
    timeLabel.text = data.measuredTime
    maxOxygenIntakeLabel.text = "\(data.heartBeatCount == 0 ? "평균 이하" : data.heartBeatCount.description)"
    maxOxygenIntakeValueLabel.text = data.unit
  }
}
