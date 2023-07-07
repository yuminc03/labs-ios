//
//  TodosDTO.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/07/07.
//

import Foundation

struct TodosDTO: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
