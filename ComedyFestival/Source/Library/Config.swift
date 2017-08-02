//
//  Config.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 02/08/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation

enum ConfigError: Error {
    case configNotFound
    case readPropertyListError(Error)
    case decodingError(Error)
}

struct Config: Decodable {
    private enum CodingKeys: String, CodingKey {
        case comedyFestivalAPIBaseURL
    }
    
    let comedyFestivalAPIBaseURL: URL
    
    init() throws {
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "plist") else {
            throw ConfigError.configNotFound
        }
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw ConfigError.readPropertyListError(error)
        }
        do {
            let decoder = PropertyListDecoder()
            self = try decoder.decode(Config.self, from: data)
        } catch {
            throw ConfigError.decodingError(error)
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawComedyFestivalAPIBaseURL = try values.decode(String.self, forKey: .comedyFestivalAPIBaseURL)
        guard let comedyFestivalAPIBaseURL = URL(string: rawComedyFestivalAPIBaseURL) else {
            throw DecodingError.typeMismatch(URL.self, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected string that can be converted to URL"))
        }
        self.comedyFestivalAPIBaseURL = comedyFestivalAPIBaseURL
    }
}
