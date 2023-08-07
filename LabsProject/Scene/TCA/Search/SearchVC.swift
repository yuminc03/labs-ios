//
//  SearchVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/08/07.
//

import UIKit

import ComposableArchitecture
import SnapKit

struct Search: ReducerProtocol {
    struct State: Equatable {
        var results = [GeocodingSearch.Result]()
        var resultForecastRequestInFlight: GeocodingSearch.Result?
        var searchQuery = ""
        var weather: Weather?
        
        struct Weather: Equatable {
            let id: GeocodingSearch.Result.ID
            let days: [Day]
            
            struct Day: Equatable {
                let date: Date
                let temperatureMax: Double
                let temperatureMaxUnit: String
                let temperatureMin: Double
                let temperatureMinUnit: String
            }
        }
    }
    
    enum Action  {
        case forecastResponse(GeocodingSearch.Result.ID, TaskResult<Forecast>)
        case didChangeSearchQuery(String)
        case didChangeSearchQueryDebounced
        case searchResponse(TaskResult<GeocodingSearch>)
        case didTapSearchResult(GeocodingSearch.Result)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}

final class SearchVC: TCABaseVC<Search> {
    
    private let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 20
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "Search"
        v.textColor = .black
        v.font = .systemFont(ofSize: 30, weight: .semibold)
        return v
    }()
    
    private let contentLabel: UILabel = {
        let v = UILabel()
        v.text = "This application demonstrates live-searching with the Composable Architecture. As you type the events are debounced for 300ms, and when you stop typing an API request is made to load locations. Then tapping on a location will load weather."
        v.textColor = .black
        return v
    }()
    
    init() {
        let store = Store(initialState: Search.State(), reducer: Search())
        super.init(store: store)
    }
    
    
}
