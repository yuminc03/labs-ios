//
//  BindingVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/02.
//

import UIKit
import Combine

import ComposableArchitecture
import SnapKit

struct BindingForm: ReducerProtocol {
    
    struct State: Equatable {
        var sliderValue = 5.0
        var stepCount = 10
        var text = ""
        var isOn = false
    }
    
    enum Action: Equatable {
        case didChangeSliderValue(Double)
        case didChangeStepCount(Int)
        case didChangeText(String)
        case didChangeToggle(isOn: Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case .didChangeSliderValue(let value):
            state.sliderValue = value
            return .none
            
        case .didChangeStepCount(let count):
            state.sliderValue = .minimum(state.sliderValue, Double(count))
            state.stepCount = count
            return .none
            
        case .didChangeText(let text):
            state.text = text
            return .none
            
        case .didChangeToggle(let isOn):
            state.isOn = isOn
            return .none
        }
    }
}

final class BindingVC: BaseVC<BindingForm> {
    
    override init(store: StoreOf<BindingForm>) {
        super.init(store: store)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        
    }
}
