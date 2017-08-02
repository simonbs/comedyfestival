//
//  HTTPClient.swift
//  ComedyFestivalKit
//
//  Created by Simon Støvring on 27/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import Alamofire

public enum HTTPClientError: Error {
    case decodingError(Error)
    case networkingError(Error)
}

protocol Endpoint {
    var path: String { get }
}

protocol HTTPClient {
    associatedtype EndpointType: Endpoint
    var baseURL: URL { get }
    var jsonDecoder: JSONDecoder { get }
    var sessionManager: Alamofire.SessionManager { get }
    var responseQueue: DispatchQueue? { get }
}

extension HTTPClient {
    var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }
    
    var sessionManager: Alamofire.SessionManager {
        return Alamofire.SessionManager.default
    }
    
    var responseQueue: DispatchQueue? {
        return nil
    }
}

extension HTTPClient {
    func get<T: Decodable>(_ endpoint: EndpointType, parameters: Parameters? = nil, parameterEncoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<HTTPClientError, T>) -> Void) -> DataRequest {
        return send(
            method: .get,
            endpoint: endpoint,
            parameters: parameters,
            parameterEncoding: parameterEncoding,
            headers: headers,
            completion: completion)
    }
}

private extension HTTPClient {
    func send<T: Decodable>(method: HTTPMethod, endpoint: EndpointType, parameters: Parameters?, parameterEncoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping (Result<HTTPClientError, T>) -> Void) -> DataRequest {
        let url = createURL(baseURL, endpoint: endpoint)
        return sessionManager.request(url, method: method, parameters: parameters, encoding: parameterEncoding, headers: headers).sbs_responseJSON(queue: responseQueue, jsonDecoder: jsonDecoder, completion: { (result: Result<JSONMappingError, T>) in
            let mappedResult: Result<HTTPClientError, T> = result.mapError { error in
                switch error {
                case .decodingError(let innerError):
                    return .decodingError(innerError)
                case .networkingError(let innerError):
                    return .networkingError(innerError)
                }
            }
            completion(mappedResult)
        })
    }
    
    func createURL(_ baseURL: URL, endpoint: EndpointType) -> URL {
        return baseURL.appendingPathComponent(endpoint.path)
    }
}
