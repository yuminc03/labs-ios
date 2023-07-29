//
//  EagerNavigationVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/28.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

struct EagerNavigation: ReducerProtocol {
    struct State: Equatable {
        var isNavigationActive = false
        var optionalCounter: Counter.State?
    }
    
    enum Action {
        case optionalCounter(Counter.Action)
        case setNavigation(isActive: Bool)
        case setNavigationIsActiveDelayCompleted
    }
    
    private enum CancelID {
        case load
    }
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .setNavigation(isActive: true):
                return .none
                
            case .setNavigation(isActive: false):
                return .none
                
            case .setNavigationIsActiveDelayCompleted:
                return .none
                
            case .optionalCounter:
                return .none
            }
        }
        .ifLet(\.optionalCounter, action: /Action.optionalCounter) {
            Counter()
        }
    }
}

final class EagerNavigationVC: TCABaseVC<EagerNavigation> {
    
    private let loadOptionalCounterButton: UIButton = {
        let view = UIButton()
        view.setTitle("Load optional counter", for: .normal)
        return view
    }()
    
    init() {
        let store = Store(
            initialState: EagerNavigation.State(),
            reducer: EagerNavigation()
        )
        super.init(store: store)
    }
    
    override func setup() {
        super.setup()
        setNavigationTitle(title: "Navigate and load")
        view.addSubview(loadOptionalCounterButton)
        
        loadOptionalCounterButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        
        viewStore.publisher.isNavigationActive
            .sink { [weak self] isNavigationActive in
                guard let self else { return }
                guard isNavigationActive else {
                    navigationController?.popToViewController(self, animated: true)
                    return
                }
                
                navigationController?.pushViewController(
                    IfLetStoreVC(
                        store: store.scope(
                            state: \.optionalCounter,
                            action: EagerNavigation.Action.optionalCounter
                        )
                    ) {
                        CounterVC(store: $0)
                    } else: {
                        ActivityIndicatorVC()
                    },
                    animated: true
                )
            }
            .store(in: &cancelBag)
        
        loadOptionalCounterButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.setNavigation(isActive: true))
            }
            .store(in: &cancelBag)
    }
    
}

final class IfLetStoreVC<State, Action>: LabsVC {
    
    let store: Store<State?, Action>
    let ifDestination: (Store<State, Action>) -> LabsVC
    let elseDestination: () -> LabsVC
    private var viewController = LabsVC() {
      willSet {
        self.viewController.willMove(toParent: nil)
        self.viewController.view.removeFromSuperview()
        self.viewController.removeFromParent()
        self.addChild(newValue)
        self.view.addSubview(newValue.view)
        newValue.didMove(toParent: self)
      }
    }
    
    init(
        store: Store<State?, Action>,
        ifDestination: @escaping (Store<State, Action>) -> LabsVC,
        else elseDestination: @escaping () -> LabsVC
    ) {
        self.store = store
        self.ifDestination = ifDestination
        self.elseDestination = elseDestination
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.ifLet(
            then: { [weak self] store in
                guard let self else { return }
                viewController = ifDestination(store)
            },
            else: { [weak self] in
                guard let self else { return }
                viewController = elseDestination()
            }
        )
        .store(in: &cancelBag)
    }
}

final class ActivityIndicatorVC: LabsVC {
    
    let activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
