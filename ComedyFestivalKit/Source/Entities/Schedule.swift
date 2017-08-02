//
//  Schedule.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation

public struct Schedule: Codable {
    public let days: [Day]
}

public struct Day: Codable {
    public let festivalDayStartDate: Date
    public let festivalDayEndDate: Date
    public let locations: [Location]
}

public struct Location: Codable {
    public enum Name: String, Codable {
        case copenhagen = "København"
        case aarhus = "Aarhus"
        case zulu = "ZULU"
    }
    
    public let name: Location.Name
    public let shows: [Show]
    
    public init(name: Location.Name, shows: [Show]) {
        self.name = name
        self.shows = shows
    }
}

public struct Show: Codable {
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case headline
        case subheadline
        case venue
        case date
        case price
        case moreInfoURL = "more_info_url"
        case ticketURL = "ticket_url"
        case isSoldOut = "is_sold_out"
        case locationName = "location"
    }
    
    public let imageURL: URL?
    public let headline: String
    public let subheadline: String?
    public let venue: String?
    public let date: Date
    public let price: Int?
    public let moreInfoURL: URL?
    public let ticketURL: URL?
    public let isSoldOut: Bool
    public let locationName: Location.Name
}

public extension Show {
    var isFree: Bool {
        return price ?? 0 == 0
    }
}

public extension Location {
    var priority: Int {
        switch name {
        case .copenhagen: return 0
        case .aarhus: return 1
        case .zulu: return 2
        }
    }
}

