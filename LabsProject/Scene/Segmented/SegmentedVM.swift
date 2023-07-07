//
//  SegmentedVM.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/07.
//

import Foundation

final class SegmentedVM {
    
    @Published private(set) var todosResult: Result<[TodosDTO], NetworkError>?
    
    func requestTodos() {
        Task {
            let api = TypiCodeAPI.todo
            do {
                let model = try await NetworkManager.request(request: api, model: [TodosDTO].self)
                todosResult = .success(model)
            } catch let error {
                todosResult = .failure(error as? NetworkError ?? .unknown)
            }
        }
    }
}
