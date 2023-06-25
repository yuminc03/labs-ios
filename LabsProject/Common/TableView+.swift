//
//  TableView+.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/25.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(type: T.Type) {
        let identifier = String(describing: type)
        register(type, forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("잘못된 identifier입니다..")
        }
        
        return cell
    }
}
