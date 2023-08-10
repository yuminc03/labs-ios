//
//  CounterFeatureView.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/08/10.
//

import SwiftUI

import ComposableArchitecture

struct CounterFeatureView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("\(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                HStack {
                    Button("-") {
                        store.send(.didTapDecrementButton)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("+") {
                        store.send(.didTapIncrementButton)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
    }
}

struct CounterFeature_Previews: PreviewProvider {
    static var previews: some View {
        CounterFeatureView(
            store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
                    ._printChanges()
        })
    }
}
