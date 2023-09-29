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
    let learnMoreInfo = LearnMoreInfo.dummy
    let aboutHeartApp = AboutHeart.dummy
  }
  
  enum Action {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}

final class HeartVC: TCABaseVC<HeartCore> {
  private let containerView: UIView = {
    let v = UIView()
    v.backgroundColor = .clear
    return v
  }()
  
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
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerView.pin.all(view.pin.safeArea)
    scrollView.pin.all()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor(named: "gray_EAEAEA")
    view.addSubview(containerView)
    containerView.addSubview(scrollView)
    scrollView.tableView.delegate = self
    scrollView.tableView.dataSource = self
    scrollView.updateUI(
      learnMoreInfo: viewStore.learnMoreInfo,
      aboutTheHeart: viewStore.aboutHeartApp
    )
  }
}

extension HeartVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section < 3 {
      return viewStore.heartBeats[section].data.count
    } else {
      return viewStore.usableData.count
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueHeaderFooter(type: HeartTableViewHeader.self)
    if section < 3 {
      header.updateUI(title: viewStore.heartBeats[section].headerTitle)
    } else {
      header.updateUI(title: "사용 가능한 데이터 없음")
    }
    return header
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section < 3 {
      if indexPath.section == 1 {
        let cell = tableView.dequeueCell(type: MaximumOxygenCell.self, indexPath: indexPath)
        cell.updateUI(data: viewStore.heartBeats[indexPath.section].data[indexPath.row])
        return cell
      } else {
        let cell = tableView.dequeueCell(type: HeartTableViewCell.self, indexPath: indexPath)
        cell.updateUI(data: viewStore.heartBeats[indexPath.section].data[indexPath.row])
        return cell
      }
    } else {
      let cell = tableView.dequeueCell(type: UnusableDataCell.self, indexPath: indexPath)
      cell.updateUI(title: viewStore.usableData[indexPath.row])
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 30
  }
}
