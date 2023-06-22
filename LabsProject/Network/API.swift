//
//  API.swift
//  SwiftUIPractiseExtample
//
//  Created by Yumin Chu on 2023/06/17.
//

import Foundation

import Alamofire

/// 네트워크 요청 보낼 때 필요한 정보를 갖는 enum
protocol API: URLRequestConvertible {
    var URLString: String { get }
    var method: HTTPMethod { get }
}

extension API {
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: URLString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.method = method
        
        return request
    }
}
