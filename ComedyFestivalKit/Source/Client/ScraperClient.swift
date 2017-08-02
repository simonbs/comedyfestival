//
//  ScraperClient.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import Alamofire

enum ScraperEndpoint: Endpoint {
    case shows
    
    var path: String {
        switch self {
        case .shows: return "shows"
        }
    }
}

public enum ScraperError: Error {
    case loadingError(HTTPClientError)
}

public class ScraperClient: HTTPClient {
    typealias EndpointType = ScraperEndpoint
    let baseURL: URL
    let jsonDecoder: JSONDecoder
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
        self.jsonDecoder = ComedyFestivalJSONDecoder()
    }
    
    @discardableResult
    func shows(completion: @escaping (Result<ScraperError, [Show]>) -> Void) -> DataRequest {
        return get(ScraperEndpoint.shows) { completion(self.mapError(in: $0)) }
    }
    
    private func mapError<T: Decodable>(in result: Result<HTTPClientError, T>) -> Result<ScraperError, T> {
        return result.mapError { error in
            return .loadingError(error)
        }
    }
}

