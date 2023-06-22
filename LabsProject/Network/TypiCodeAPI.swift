//
//  TodoAPI.swift
//  SwiftUIPractiseExtample
//
//  Created by Yumin Chu on 2023/06/18.
//

import Foundation

import Alamofire

enum TypiCodeAPI: API {
    case todo
    
    var URLString: String {
        return "https://jsonplaceholder.typicode.com/todos"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
}
