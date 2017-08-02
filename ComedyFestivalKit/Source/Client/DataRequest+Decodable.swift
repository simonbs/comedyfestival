//
//  DataRequest+Decodable.swift
//  ComedyFestivalKit
//
//  Created by Simon Støvring on 27/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import Alamofire

enum JSONMappingError: Error {
    case decodingError(Error)
    case networkingError(Error)
}

extension DataRequest {
    @discardableResult
    func sbs_responseJSON<T: Decodable>(queue: DispatchQueue? = nil, jsonDecoder: JSONDecoder, completion: @escaping (Result<JSONMappingError, T>) -> Void) -> DataRequest {
        return responseData(queue: queue) { response in
            switch response.result {
            case .success(let data):
                do {
                    let value = try jsonDecoder.decode(T.self, from: data)
                    completion(.value(value))
                } catch {
                    completion(.error(.decodingError(error)))
                }
            case .failure(let error):
                completion(.error(.networkingError(error)))
            }
        }
    }
}

