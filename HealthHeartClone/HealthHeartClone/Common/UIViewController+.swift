//
//  UIViewController+.swift
//  HealthHeartClone
//
//  Created by Yumin Chu on 2023/09/25.
//

import UIKit
#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
  private struct Preview: UIViewControllerRepresentable {
    let vc: UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
      return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
      
    }
  }
  
  func toPreview() -> some View {
    Preview(vc: self)
  }
}
#endif
