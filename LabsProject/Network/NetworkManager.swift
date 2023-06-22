//
//  NetworkManager.swift
//  SwiftUIPractiseExtample
//
//  Created by Yumin Chu on 2023/06/17.
//

import Foundation

import Alamofire

/**
 네트워크 통신에서 발생하는 오류를 모은 enum
 - networkError : 네트워크 오류
 - invalidStatusCode : 유효하지 않은 오류 코드
 - invalidURL : 유효하지 않은 URL
 - unknown : 알 수 없는 오류
 */
enum NetworkError: Error {
    case networkError
    case invalidStatusCode
    case invalidURL
    case unknown
}

final class NetworkManager {
    
    /// 네트워크 요청 보내는 함수
    /// - Parameters:
    ///   - request: 요청할 정보가 담긴 API
    ///   - model: 데이터를 decode할 Model
    /// - Returns: T : decode된 형태의 model
    func request<T: Decodable>(request: API, model: T.Type) async throws -> T {
        guard NetworkReachabilityManager()?.isReachable == true else {
            throw NetworkError.networkError
        }
        
        let dataTask = await AF.request(request).serializingDecodable(T.self).result
        switch dataTask {
        case .success(let model):
            return model
            
        case .failure(let failure):
            if let _ = failure.responseCode {
                throw NetworkError.invalidStatusCode
            } else {
                throw NetworkError.unknown
            }
        }
    }
}
