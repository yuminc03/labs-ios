import UIKit

import FlexLayout
import PinLayout

final class HeartVC: UIViewController {
  private let scrollView: UIScrollView = {
    let v = UIScrollView()
    return v
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBlue
    
  }
  
  private func setupConstraints() {
    
  }
}
