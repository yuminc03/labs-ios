//
//  UnusableDataCell.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/28.
//

import UIKit

import FlexLayout
import PinLayout

/// 사용 가능하지 않은 데이터 Cell
final class UnusableDataCell: UITableViewCell {
  private let containerView: UIView = {
    let v = UIView()
    v.backgroundColor = .white
    return v
  }()
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = .black
    v.font = .systemFont(ofSize: 16, weight: .bold)
    return v
  }()
  
  private let rightArrowImage: UIImageView = {
    let v = UIImageView()
    v.image = UIImage(systemName: "chevron.right")
    v.tintColor = .lightGray
    return v
  }()
  
  private let separator: UIView = {
    let v = UIView()
    v.backgroundColor = UIColor(named: "gray_EAEAEA")
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
    contentView.pin.width(size.width)
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
    contentView.flex.define {
      $0.addItem(containerView).padding(18, 20).define {
        $0.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.center).define {
          $0.addItem(titleLabel)
          $0.addItem(rightArrowImage).width(10).aspectRatio(of: rightArrowImage)
        }
      }
      $0.addItem().backgroundColor(.white).define {
        $0.addItem().paddingLeft(20).define {
          $0.addItem(separator).height(1)
        }
      }
    }
  }
  
  func updateUI(title: String) {
    titleLabel.text = title
  }
}
