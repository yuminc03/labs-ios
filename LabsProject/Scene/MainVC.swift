//
//  ViewController.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/04/21.
//

import UIKit

class MainVC: UIViewController {

    private let tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.backgroundColor = .clear
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }

    private func setupUI() {
        
    }
    
    private func setupConstraints() {
        
    }
}

