import UIKit

import FlexLayout
import PinLayout

final class HeartVC: UIViewController {
  private let scrollView = HeartScrollView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView.pin.margin(view.pin.safeArea)
    scrollView.flex.layout(mode: .adjustHeight)
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.tableView.delegate = self
    scrollView.tableView.dataSource = self
  }
  
  private func setupConstraints() {
    
  }
}

extension HeartVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}
