//
//  UIColor+.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/25.
//

import UIKit

enum LabsColor: String {
    
    case gray_EAEAEA
}

func labsColor(_ color: LabsColor) -> UIColor? {
    UIColor(named: color.rawValue)
}
