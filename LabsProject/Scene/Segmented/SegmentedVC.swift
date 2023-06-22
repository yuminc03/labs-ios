//
//  SegmentedVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/22.
//

import UIKit

import SnapKit

final class SegmentedVC: LabsVC {
    
    private let segmentedView: UISegmentedControl = {
        let view = UISegmentedControl(items: ["todos", "photos"])
        view.selectedSegmentIndex = 0
        return view
    }()
    
    private let todosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: (UIScreen.main.bounds.width - 100) / 2,
            height: 500
        )
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
//        view.delegate = self
//        view.dataSource = self
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstarints()
        
    }
    
    private func setupUI() {
        view.addSubview(segmentedView)
        view.addSubview(todosCollectionView)
        
    }
    
    private func setupConstarints() {
        segmentedView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
        }
        
        todosCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.top.equalTo(segmentedView.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
    }
}
