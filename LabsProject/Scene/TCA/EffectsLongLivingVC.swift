//
//  EffectsLongLivingVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/23.
//

import UIKit
import Combine

import CombineCocoa
import ComposableArchitecture
import SnapKit

struct EffectsLongLiving: ReducerProtocol {
    struct State: Equatable {
        var screenShotCount = 0
    }
    
    enum Action {
        case task
        case userDidTakeScreenShotNotification
    }
    
    @Dependency(\.screenshots) var screenshots
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .task:
            return .run { send in
                for await _ in await screenshots() {
                    await send(.userDidTakeScreenShotNotification)
                }
            }
            
        case .userDidTakeScreenShotNotification:
            state.screenShotCount += 1
            return .none
        }
    }
}

extension DependencyValues {
    var screenshots: @Sendable () async -> AsyncStream<Void> {
        get { self[ScreenshotsKey.self] }
        set { self[ScreenshotsKey.self] = newValue }
    }
}

private enum ScreenshotsKey: DependencyKey {
    static var liveValue: @Sendable () async -> AsyncStream<Void> = {
        await AsyncStream(
            NotificationCenter.default.notifications(
                named: UIApplication.userDidTakeScreenshotNotification
            ).map { _ in }
        )
    }
}

final class EffectsLongLivingVC: TCABaseVC<EffectsLongLiving> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 40
        return view
    }()
    
    private let screenshotLabelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let screenshotLabel: UILabel = {
        let view = UILabel()
        view.textColor = labsColor(.gray_2F2F2F)
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.numberOfLines = 0
        return view
    }()

    private let navigateButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Navigate to another screen"
        config.image = UIImage(systemName: "chevron.right")
        config.image?.withTintColor(.systemGray5)
        config.imagePlacement = .trailing
        config.imagePadding = 50
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        let view = UIButton(configuration: config)
        view.backgroundColor = .white
        view.setTitleColor(labsColor(.gray_2F2F2F), for: .normal)
        view.layer.cornerRadius = 10
        return view
    }()

    override func setup() {
        super.setup()
        view.backgroundColor = .systemGray6
        view.addSubview(stackView)
        setNavigationTitle(title: "Long-living effects")
        
        stackView.addArrangedSubview(screenshotLabelContainerView)
        stackView.addArrangedSubview(navigateButton)
        screenshotLabelContainerView.addSubview(screenshotLabel)
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        screenshotLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        sendTask()
    }
    
    override func bind() {
        super.bind()
        
        viewStore.publisher.screenShotCount
            .sink { [weak self] count in
                self?.screenshotLabel.text = "A screenshot of this screen has been taken \(count) times."
            }
            .store(in: &cancelBag)
        
        navigateButton.tapPublisher
            .sink { [weak self] _ in
                self?.navigationController?.pushViewController(
                    EffectsLongLivingChildVC(),
                    animated: true
                )
            }
            .store(in: &cancelBag)
    }
    
    private func sendTask() {
        Task {
            await viewStore.send(.task).finish()
        }
    }
}

final class EffectsLongLivingChildVC: LabsVC {
    
    private let navigationBar = NavigationBarView(title: "Long-living effects")
    private let contentsLabel: UILabel = {
        let view = UILabel()
        view.text = "Take a screenshot of this screen a few times, and then go back to the previous screen to see that those screenshots were not counted."
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bind()
    }
    
    private func bind() {
        navigationBar.backButton.tapPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
    }
    
    private func setupUI() {
        view.addSubview(navigationBar)
        view.addSubview(contentsLabel)
    }
    
    private func setupConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(109)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
