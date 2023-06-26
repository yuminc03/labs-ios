//
//  BaseVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/26.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture

class BaseVC<R: ReducerProtocol>: UIViewController where R.State: Equatable {
    
    var cancelBag = Set<AnyCancellable>()
    var store: StoreOf<R>
    var viewStore: ViewStoreOf<R>
    
    init(store: StoreOf<R>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
//        let counterVC = CounterVC(
//            store: Store(initialState: Counter.State(), reducer: Counter())
//        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind()
    }
    
    func setup() { }
    func bind() { }
}
