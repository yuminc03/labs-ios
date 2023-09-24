//
//  PresentAndLoadVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/09/24.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

struct PresentAndLoadCore: Reducer {
  struct State: Equatable {
    var counter: Counter.State?
    var isSheetPresented = false
  }
  
  enum Action {
    case counter(Counter.Action)
    case setSheet(isPresented: Bool)
    case isSheetPresentedDelayCompleted
  }
  
  @Dependency(\.continuousClock) var clock
  private enum CancelID {
    case load
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .setSheet(isPresented: true):
        state.isSheetPresented = true
        return .run { send in
          try await clock.sleep(for: .seconds(1))
          await send(.isSheetPresentedDelayCompleted)
        }
        .cancellable(id: CancelID.load)
        
      case .setSheet(isPresented: false):
        state.isSheetPresented = false
        state.counter = nil
        return .cancel(id: CancelID.load)
        
      case .isSheetPresentedDelayCompleted:
        state.counter = Counter.State()
        return .none
        
      case .counter:
        return .none
      }
    }
    .ifLet(\.counter, action: /Action.counter) {
      Counter()
    }
  }
}

final class PresentAndLoadVC: TCABaseVC<PresentAndLoadCore> {
  private let loadCounterButton: UIButton = {
    let v = UIButton()
    v.setTitle("Load optional counter", for: .normal)
    v.setTitleColor(.systemBlue, for: .normal)
    return v
  }()
  
  init() {
    let store = Store(initialState: PresentAndLoadCore.State()) {
      PresentAndLoadCore()
        ._printChanges()
    }
    super.init(store: store)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupConstraints()
    bind()
  }
  
  override func bind() {
    super.bind()
    
    loadCounterButton.tapPublisher
      .sink { [weak self] in
        self?.store.send(.setSheet(isPresented: true))
      }
      .store(in: &cancelBag)
    
    store.scope(
      state: \.counter,
      action: PresentAndLoadCore.Action.counter
    )
    .ifLet(then: { [weak self] store in
      let vc = CounterVC(store: store)
      vc.navigationBar.isHidden = true
      vc.modalPresentationStyle = .popover
      self?.present(vc, animated: true)
    })
    .store(in: &cancelBag)
  }
  
  override func setup() {
    super.setup()
    setNavigationTitle(title: "Present and load data")
    view.addSubview(loadCounterButton)
  }
  
  private func setupConstraints() {
    loadCounterButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(50)
      $0.centerY.equalToSuperview()
    }
  }
}
