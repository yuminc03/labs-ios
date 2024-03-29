//
//  TimersVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/26.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

struct Timers: Reducer {
    struct State: Equatable {
      var isTimerActive = false
      var secondsElapsed = 0
    }
    
    enum Action {
        case onDisappear
        case timerTicked
        case didTapToggleTimerButton
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID {
        case timer
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onDisappear:
            return .cancel(id: CancelID.timer)
            
        case .timerTicked:
            state.secondsElapsed += 1
            return .none
            
        case .didTapToggleTimerButton:
            state.isTimerActive.toggle()
            return .run { [isTimerActive = state.isTimerActive] send in
                guard isTimerActive else { return }
                for await _ in clock.timer(interval: .seconds(1)) {
                    await send(.timerTicked, animation: .interpolatingSpring(stiffness: 3000, damping: 40))
                }
            }
            .cancellable(id: CancelID.timer, cancelInFlight: true)
        }
    }
}

final class TimersVC: TCABaseVC<Timers> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()

    private let clockView = ClockView()
    
    private let startButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let view = UIButton(configuration: config)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        return view
    }()
    
    init() {
        let store = Store(initialState: Timers.State()) {
            Timers()
        }
        super.init(store: store)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewStore.send(.onDisappear)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayer()
    }
    
    override func setup() {
        super.setup()
        setNavigationTitle(title: "Timers")
        view.addSubview(stackView)
        stackView.addArrangedSubview(clockView)
        stackView.addArrangedSubview(startButton)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        clockView.snp.makeConstraints {
            $0.width.height.equalTo(280)
        }
    }
    
    override func bind() {
        super.bind()
        startButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapToggleTimerButton)
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.isTimerActive
            .sink { [weak self] in
                self?.startButton.setTitle($0 ? "Stop" : "Start", for: .normal)
                self?.startButton.backgroundColor = $0 ? .systemRed : .systemBlue
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.secondsElapsed
            .sink { [weak self] seconds in
                self?.clockView.updateElapsed(secondsElapsed: seconds)
            }
            .store(in: &cancelBag)
    }
    
    private func setLayer() {
        let colors = [
            UIColor.systemBlue.withAlphaComponent(0.3).cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.systemGreen.cgColor,
            UIColor.systemGreen.cgColor,
            UIColor.systemYellow.cgColor,
            UIColor.systemYellow.cgColor,
            UIColor.systemRed.cgColor,
            UIColor.systemRed.cgColor,
            UIColor.systemPurple.cgColor,
            UIColor.systemPurple.cgColor,
            UIColor.systemPurple.withAlphaComponent(0.3).cgColor
          ]
        let gradient = CAGradientLayer()
        gradient.frame = clockView.bounds
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.type = .conic
        clockView.layer.addSublayer(gradient)
    }
}
