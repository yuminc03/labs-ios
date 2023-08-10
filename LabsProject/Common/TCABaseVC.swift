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
import SnapKit

class TCABaseVC<R: Reducer>: LabsVC where R.State: Equatable {
    
    var store: StoreOf<R>
    var viewStore: ViewStoreOf<R>
    let navigationBar = NavigationBarView(title: "Counter")

    init(store: StoreOf<R>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(109)
        }
        
        navigationBar.backButton.tapPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
        setup()
        bind()
    }
    
    func setNavigationTitle(title: String) {
        navigationBar.titleLabel.text = title
    }
    
    func setup() { }
    func bind() { }
}
