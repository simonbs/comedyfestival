//
//  ShowsViewModeScheduleViewModel.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 28/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import ComedyFestivalKit
import Alamofire

class ScheduleViewModel {
    var didReload: (() -> Void)?
    var didFailReloading: ((Error) -> Void)?
    var didSearch: (([Location]) -> Void)?
    
    private(set) var menuTitles: [String] = []
    private(set) var days: [Day] = []
    
    private let scheduleManager: ScheduleManager
    private var schedule: Schedule?
    private let relativeDateFormatter = RelativeDateFormatter(showsTime: false)
    private let searchOperationQueue = OperationQueue().sbs_make { me in
        me.qualityOfService = .userInitiated
        me.maxConcurrentOperationCount = 1
    }
    
    init(appSession: AppSession) {
        self.scheduleManager = ScheduleManager(scraperClient: appSession.scraperClient)
    }
    
    func reload() {
        // Get cached schedule.
        scheduleManager.cached { [weak self] cacheResult in
            cacheResult.ifValue { schedule in
                guard let strongSelf = self else { return }
                strongSelf.schedule = schedule
                strongSelf.menuTitles = strongSelf.menuTitles(from: schedule)
                strongSelf.days = schedule.days
                strongSelf.didReload?()
            }
            // Load new schedule.
            self?.scheduleManager.refresh { refreshResult in
                cacheResult.ifValue { schedule in
                    guard let strongSelf = self else { return }
                    strongSelf.schedule = schedule
                    strongSelf.menuTitles = strongSelf.menuTitles(from: schedule)
                    strongSelf.days = schedule.days
                    strongSelf.didReload?()
                }.ifError { error in
                    if self?.schedule == nil {
                        // We don't already have a schedule so we present an error.
                        self?.didFailReloading?(error)
                    }
                }
            }
        }
    }
    
    func search(for query: String) {
        guard let schedule = schedule else { return }
        searchOperationQueue.cancelAllOperations()
        let searchOperation = SearchOperation(query: query, schedule: schedule)
        searchOperation.resultsCompletion = { [weak self] locations in
            DispatchQueue.main.async {
                self?.didSearch?(locations)
            }            
        }
        searchOperationQueue.addOperation(searchOperation)
    }
}

private extension ScheduleViewModel {
    func menuTitles(from schedule: Schedule) -> [String] {
        return schedule.days.map { relativeDateFormatter.string(from: $0.festivalDayStartDate) }
    }
}

private class SearchOperation: Operation {
    private let query: String
    private let schedule: Schedule
    
    var resultsCompletion: (([Location]) -> Void)?
    
    init(query: String, schedule: Schedule) {
        self.query = query
        self.schedule = schedule
    }
    
    override func main() {
        super.main()
        guard !isCancelled else { return }
        let lowercasedQuery = query.lowercased()
        var results: [Location.Name: [Show]] = [:]
        for day in schedule.days {
            for location in day.locations {
                let filteredShows = location.shows.filter { show in
                    let headlineMatch = show.headline.lowercased().contains(lowercasedQuery)
                    let subheadlineMatch = (show.subheadline ?? "").lowercased().contains(lowercasedQuery)
                    return headlineMatch || subheadlineMatch
                }
                if !filteredShows.isEmpty {
                    let currentShows = results[location.name] ?? []
                    results[location.name] = currentShows + filteredShows
                }
            }
        }
        guard !isCancelled else { return }
        let locations: [Location] = results.map { (locationName, shows) in
            let sortedShows = shows.sorted(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
            return Location(name: locationName, shows: sortedShows)
        }
        let sortedLocations = locations.sorted { $0.priority < $1.priority }
        guard !isCancelled else { return }
        resultsCompletion?(sortedLocations)
    }
}
