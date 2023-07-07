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
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.registerItem(type: TodoListCell.self)
        return view
    }()

    private let photoesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 40
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
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
        
        todosCollectionView.delegate = self
        todosCollectionView.dataSource = self
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

extension SegmentedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension SegmentedVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
}
