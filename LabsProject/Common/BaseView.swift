//
//  BaseView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/26.
//

import UIKit
import Combine

import ComposableArchitecture

class BaseView<R: ReducerProtocol>: UIView where R.State: Equatable {
    
    var cancelBag = Set<AnyCancellable>()
    var store: StoreOf<R>
    var viewStore: ViewStoreOf<R>
    
    init(store: StoreOf<R>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(frame: .zero)
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }
    
    func setupUI() { }
    
    func bind() { }
}
