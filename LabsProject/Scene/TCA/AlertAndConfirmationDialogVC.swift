//
//  AlertAndConfirmationDialogVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/16.
//

import UIKit

import CombineCocoa
import ComposableArchitecture
import SnapKit

final class AlertAndConfirmationDialogVC: TCABaseVC<AlertAndConfirmationDialog> {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let textContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let countLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    private let separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        return view
    }()
    
    private let presentAlertButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Alert"
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10)
        let view = UIButton(configuration: config)
        view.backgroundColor = .white
        view.setTitleColor(.systemBlue, for: .normal)
        return view
    }()

    private let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = labsColor(.gray_EAEAEA)
        return view
    }()
    
    private let presentActionSheetButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Confirmation Dialog"
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10)
        let view = UIButton(configuration: config)
        view.backgroundColor = .white
        view.setTitleColor(.systemBlue, for: .normal)
        return view
    }()
    
    init() {
        let store = Store(initialState: AlertAndConfirmationDialog.State()) {
            AlertAndConfirmationDialog()
        }
        super.init(store: store)
    }
    
    override func setup() {
        view.backgroundColor = .systemGray6
        view.addSubview(stackView)
        setNavigationTitle(title: "Alerts & Dialogs")
        
        [textContainerView, separatorView1, presentAlertButton, separatorView2, presentActionSheetButton].forEach { subview in
            stackView.addArrangedSubview(subview)
        }
        textContainerView.addSubview(countLabel)
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        separatorView1.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        separatorView2.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
    
    override func bind() {
        viewStore.publisher.currentCount
            .sink { [weak self] count in
                self?.countLabel.text = "Count: \(count)"
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.alert
            .sink { [weak self] alert in
                guard let alert else { return }
                self?.presentAlert(alert: alert)
            }
            .store(in: &cancelBag)
        
        viewStore.publisher.confirmationDialog
            .sink { [weak self] actionSheet in
                guard let actionSheet else { return }
                self?.presentActionSheet(actionSheet: actionSheet)
            }
            .store(in: &cancelBag)
        
        presentAlertButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapAlertButton)
            }
            .store(in: &cancelBag)
        
        presentActionSheetButton.tapPublisher
            .sink { [weak self] in
                self?.viewStore.send(.didTapConfirmationDialogButton)
            }
            .store(in: &cancelBag)
    }
    
    private func presentAlert(alert: AlertState<AlertAndConfirmationDialog.Action>) {
        let alertVC = UIAlertController(
            title: String(state: alert.title),
            message: String(state: alert.message ?? TextState("")),
            preferredStyle: .alert
        )
        alertVC.addAction(
            UIAlertAction(
                title: String(state: alert.buttons.first?.label ?? TextState("OK")),
                style: .cancel
            ) { _ in
                self.viewStore.send(.alertDismissed)
            }
        )
        
        if alert.buttons.count > 1 {
            alertVC.addAction(
                UIAlertAction(
                    title: String(state: alert.buttons.last?.label ?? TextState("")),
                    style: .default
                ) { _ in
                    self.viewStore.send(.didTapIncrementButton)
                }
            )
        }
        self.present(alertVC, animated: true)
    }
    
    private func presentActionSheet(actionSheet: ConfirmationDialogState<AlertAndConfirmationDialog.Action>) {
        let actionSheetVC = UIAlertController(
            title: String(state: actionSheet.message ?? TextState("")),
            message: nil,
            preferredStyle: .actionSheet
        )
        actionSheetVC.addAction(
            UIAlertAction(
                title: String(state: actionSheet.buttons.first?.label ?? TextState("")),
                style: .cancel
            ) { _ in
                self.viewStore.send(.confirmationDialogDismissed)
            }
        )
        if actionSheet.buttons.count > 1 {
            actionSheetVC.addAction(
                UIAlertAction(
                    title: String(state: actionSheet.buttons[1].label),
                    style: .default
                ) { _ in
                    self.viewStore.send(.didTapIncrementButton)
                }
            )
            actionSheetVC.addAction(
                UIAlertAction(
                    title: String(state: actionSheet.buttons.last?.label ?? TextState("")),
                    style: .default
                ) { _ in
                    self.viewStore.send(.didTapDecrementButton)
                }
            )
        }
        self.present(actionSheetVC, animated: true)
    }
}
