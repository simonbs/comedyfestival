//
//  SessioAppSession.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 02/08/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import ComedyFestivalKit

class AppSession {
    let scraperClient: ScraperClient
    
    init(scraperClient: ScraperClient) {
        self.scraperClient = scraperClient
    }
}
