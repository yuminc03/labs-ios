//
//  Search.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/08/07.
//

import Foundation

import ComposableArchitecture

struct Search: ReducerProtocol {
    
    @Dependency(\.weatherClient) var weatherClient
    private enum CancelID {
        case location
        case weather
    }
    
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
    
    enum Action {
        case forecastResponse(GeocodingSearch.Result.ID, TaskResult<Forecast>)
        case didChangeSearchQuery(String)
        case didChangeSearchQueryDebounced
        case searchResponse(TaskResult<GeocodingSearch>)
        case didTapSearchResult(GeocodingSearch.Result)
        case searchQueryTesk
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .forecastResponse(_, .failure):
            state.weather = nil
            state.resultForecastRequestInFlight = nil
            return .none
            
        case let .forecastResponse(id, .success(forecast)):
            state.weather = State.Weather(
                id: id,
                days: forecast.daily.time.indices.map {
                    State.Weather.Day(
                        date: forecast.daily.time[$0],
                        temperatureMax: forecast.daily.temperatureMax[$0],
                        temperatureMaxUnit: forecast.dailyUnits.temperatureMax,
                        temperatureMin: forecast.daily.temperatureMin[$0],
                        temperatureMinUnit: forecast.dailyUnits.temperatureMin
                    )
                }
            )
            state.resultForecastRequestInFlight = nil
            return .none
            
        case let .didChangeSearchQuery(query):
            state.searchQuery = query
            guard query.isEmpty == false else {
                state.results = []
                state.weather = nil
                return .cancel(id: CancelID.location)
            }
            
            return .none
            
        case .didChangeSearchQueryDebounced:
            guard state.searchQuery.isEmpty == false else {
                return .none
            }
            
            return .run { [query = state.searchQuery] send in
                await send(.searchResponse(
                    TaskResult { try await
                        weatherClient.search(query)
                    }
                ))
            }
            .cancellable(id: CancelID.location)
            
        case .searchResponse(.failure):
            state.results = []
            return .none
            
        case let .searchResponse(.success(response)):
            state.results = response.results
            return .none
            
        case let .didTapSearchResult(location):
            state.resultForecastRequestInFlight = location
            return .run { send in
                await send(.forecastResponse(
                    location.id,
                    TaskResult {
                        try await weatherClient.forecast(location)
                    }
                ))
            }
            .cancellable(id: CancelID.weather, cancelInFlight: true)
            
        case .searchQueryTesk:
            lk
        }
    }
}
