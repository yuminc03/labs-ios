import UIKit

import FlexLayout
import PinLayout

final class IntroView: UIView {
  private let rootView: UIView = {
    let v = UIView()
    v.backgroundColor = .white
    return v
  }()
  
  private let imageView = UIImageView(image: UIImage(named: "flexlayout-logo"))
  
  private let segmentedControl: UISegmentedControl = {
    let v = UISegmentedControl(items: ["Intro", "FlexLayout", "PinLayout"])
    v.selectedSegmentIndex = 0
    return v
  }()
  
  private let contentsLabel: UILabel = {
    let v = UILabel()
    v.text = "Flexbox layouting is simple, powerfull and fast.\n\nFlexLayout syntax is concise and chainable."
    v.numberOfLines = 0
    v.textColor = .black
    return v
  }()
  
  private let bottomLabel: UILabel = {
    let v = UILabel()
    v.text = "FlexLayout/yoga is incredibly fast, its even faster than manual layout."
    v.numberOfLines = 0
    return v
  }()
  
  init() {
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
  }
  
  private func setupUI() {
    rootView.flex.direction(.column).padding(12).define {
      $0.addItem().direction(.row).define {
        $0.addItem(imageView).width(100).aspectRatio(of: imageView)
        $0.addItem().direction(.column).paddingLeft(12).grow(1).shrink(1).define {
          $0.addItem(segmentedControl).marginBottom(12).grow(1)
          $0.addItem(contentsLabel)
        }
      }
      
      $0.addItem().height(1).marginTop(12).backgroundColor(.lightGray)
      $0.addItem(bottomLabel).marginTop(12)
    }
    addSubview(rootView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootView.pin.top().horizontally().margin(pin.safeArea)
    rootView.flex.layout(mode: .adjustHeight)
  }
}
