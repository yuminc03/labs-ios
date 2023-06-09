//
//  LabsVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/01.
//

import UIKit

import Combine

class LabsVC: UIViewController {
    
    var cancelBag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension LabsVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        navigationController?.viewControllers.count ?? 0 > 1
    }
}
