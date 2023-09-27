import UIKit

import ComposableArchitecture
import FlexLayout
import PinLayout

struct HeartCore: Reducer {
  struct State: Equatable {
    let heartBeats = HeartBeat.dummy
    let usableData = [
      "고심박수 알림",
      "말초 관류 지수",
      "불규칙한 박동 알림",
      "심방세동 기록",
      "심전도(ECG)",
      "유산소 피트니스 알림",
      "저심박수 알림",
      "혈압"
    ]
    let aboutHeartApp = AboutHeart.dummy
  }
  
  enum Action {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}

final class HeartVC: TCABaseVC<HeartCore> {
  private let scrollView = HeartScrollView()
  
  init() {
    let store = Store(initialState: HeartCore.State()) {
      HeartCore()
    }
    super.init(store: store)
  }
  
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
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueHeaderFooter(type: HeartTableViewHeader.self)
    
    return header
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}
