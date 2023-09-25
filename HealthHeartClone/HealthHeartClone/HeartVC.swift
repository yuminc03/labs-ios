import UIKit

import FlexLayout
import PinLayout

final class HeartVC: UIViewController {
  private let tableView: UITableView = {
    let v = UITableView()
    v.backgroundColor = .clear
    v.separatorStyle = .none
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

