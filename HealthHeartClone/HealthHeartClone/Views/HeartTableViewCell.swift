//
//  HeartTableViewCell.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/25.
//

import UIKit

import FlexLayout
import PinLayout

final class HeartTableViewCell: UITableViewCell {
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
  
  private let heartBeatLabel: UILabel = {
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
  
  private let heartBeatCountLabel: UILabel = {
    let v = UILabel()
    v.textColor = .black
    v.font = .systemFont(ofSize: 27, weight: .bold)
    v.sizeToFit()
    return v
  }()
  
  private let bpmLabel: UILabel = {
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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.flex.layout(mode: .adjustHeight)
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.flex.width(size.width)
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
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
            $0.addItem(heartBeatLabel).marginLeft(5)
          }
          $0.addItem().direction(.row).alignItems(.center).define {
            $0.addItem(timeLabel)
            $0.addItem(rightArrowImage).width(10).aspectRatio(of: rightArrowImage).marginLeft(10)
          }
        }
        $0.addItem().direction(.row).alignItems(.baseline).marginTop(20).define {
          $0.addItem(heartBeatCountLabel)
          $0.addItem(bpmLabel).marginLeft(5)
        }
      }
    }
  }
  
  func updateUI(data: HeartBeat.Heart) {
    heartBeatLabel.text = data.title
    timeLabel.text = data.measuredTime
    heartBeatCountLabel.text = "\(data.heartBeatCount == 0 ? "평균 이하" : data.heartBeatCount.description)"
    bpmLabel.text = data.unit
  }
}
