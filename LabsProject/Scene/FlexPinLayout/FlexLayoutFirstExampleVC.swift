import UIKit

import FlexLayout
import PinLayout

final class FlexLayoutFirstExampleVC: LabsVC {
  
  override func loadView() {
    super.loadView()
    view = IntroView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    
  }
}
