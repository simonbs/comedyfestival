//
//  EncoderDecoder.swift
//  ComedyFestivalKit
//
//  Created by Simon Støvring on 30/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation

class ComedyFestivalJSONEncoder: JSONEncoder {
    override init() {
        super.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Copenhagen")
        dateEncodingStrategy = .formatted(dateFormatter)
    }
}

class ComedyFestivalJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Copenhagen")
        dateDecodingStrategy = .formatted(dateFormatter)
    }
}
