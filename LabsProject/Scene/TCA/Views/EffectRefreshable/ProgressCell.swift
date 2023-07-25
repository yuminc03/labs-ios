//
//  ProgressCell.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/25.
//

import UIKit

import SnapKit

final class ProgressCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }
    
    private func setupUI() {
        
    }
    
    private func setupConstraints() {
        
    }
}
