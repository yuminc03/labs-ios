//
//  ClockView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/26.
//

import UIKit

final class ClockView: UIView {
    
    private let clockHandPath: UIBezierPath = {
        let view = UIBezierPath()
        view.lineWidth = 3
        view.lineJoinStyle = .round
        UIColor.black.set()
        return view
    }()
    var secondsElapsed = 0

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clockHandPath.move(to: center)
        let angle = CGFloat.pi / 180 * 6 * CGFloat(secondsElapsed * 5)
        let hourTo = CGPoint(x: center.x + 140 * sin(angle), y: center.x - 140 * cos(angle))
        clockHandPath.addLine(to: hourTo)
        let clockHandLayer = CAShapeLayer()
        clockHandLayer.path = clockHandPath.cgPath
        clockHandLayer.lineWidth = 3
        clockHandLayer.strokeColor = UIColor.black.cgColor
        clockHandLayer.lineCap = .round
        layer.addSublayer(clockHandLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use Storyboard.")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        layer.masksToBounds = true
        layer.cornerRadius = 140
    }
    
    func updateElapsed(secondsElapsed: Int) {
        self.secondsElapsed = secondsElapsed
        layoutIfNeeded()
    }
}
