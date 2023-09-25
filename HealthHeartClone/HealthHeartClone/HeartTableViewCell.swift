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
    v.layer.cornerRadius = 5
    return v
  }()
  
  private let heartImageView: UIImageView = {
    let v = UIImageView()
    v.image = UIImage(named: "heart.fill")
    v.tintColor = .systemPink
    return v
  }()
  
  private let heartBeatLabel: UILabel = {
    let v = UILabel()
    v.textColor = .systemPink
    v.font = .systemFont(ofSize: 16)
    return v
  }()
  
  private let timeLabel: UILabel = {
    let v = UILabel()
    v.textColor = .lightGray
    v.font = .systemFont(ofSize: 12)
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
    v.font = .systemFont(ofSize: 24, weight: .medium)
    return v
  }()
  
  private let bpmLabel: UILabel = {
    let v = UILabel()
    v.textColor = .gray
    v.font = .systemFont(ofSize: 16)
    return v
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
  }
  
  private func setupUI() {
    backgroundColor = .clear
    selectionStyle = .none
    contentView.addSubview(containerView)
  }
  
  private func setupConstraints() {
    containerView.flex.direction(.column).padding(20, 20).define {
      $0.addItem().direction(.row).justifyContent(.spaceBetween).define {
        $0.addItem().direction(.row).padding(0, 1).define {
          $0.addItem(heartImageView).width(10).aspectRatio(1)
        }
      }
    }
  }
}
