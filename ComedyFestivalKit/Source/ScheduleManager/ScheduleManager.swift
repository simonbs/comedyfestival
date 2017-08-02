//
//  ScheduleManager.swift
//  ComedyFestivalKit
//
//  Created by Simon Støvring on 30/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation

public enum ScheduleManagerError: Error {
    case cannotCreateCacheURL
    case loadError(ScraperError)
    case cacheWriteError(Error)
    case cannotReadCacheError(Error)
    case cannotCreateFestivalStartDate
}

public class ScheduleManager {
    private let scraperClient: ScraperClient
    private let queue: DispatchQueue = .global(qos: .userInitiated)
    private var cacheURL: URL? {
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        return URL(fileURLWithPath: documentsPath).appendingPathComponent("schedule.json")
    }
    
    public init(scraperClient: ScraperClient) {
        self.scraperClient = scraperClient
    }
    
    public func cached(completion: @escaping (Result<ScheduleManagerError, Schedule>) -> Void) {
        queue.async {
            guard let cacheURL = self.cacheURL else {
                return completion(.error(.cannotCreateCacheURL))
            }
            do {
                let data = try Data(contentsOf: cacheURL)
                let jsonDecoder = ComedyFestivalJSONDecoder()
                let schedule = try jsonDecoder.decode(Schedule.self, from: data)
                DispatchQueue.main.async {
                    completion(.value(schedule))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.error(.cannotReadCacheError(error)))
                }
            }
        }
    }
    
    public func refresh(completion: @escaping (Result<ScheduleManagerError, Schedule>) -> Void) {
        scraperClient.shows { [weak self] scraperResult in
            guard let strongSelf = self else { return }
            scraperResult.mapError { error in
                return .loadError(error)
            }.ifValue { shows in
                guard let cacheURL = strongSelf.cacheURL else {
                    return completion(.error(.cannotCreateCacheURL))
                }
                strongSelf.queue.async {
                    do {
                        let newSchedule = try strongSelf.schedule(from: shows)
                        try strongSelf.encode(newSchedule, storeAt: cacheURL)
                        DispatchQueue.main.async {
                            completion(.value(newSchedule))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.error(.cacheWriteError(error)))
                        }
                    }
                }
            }.ifError { (error: ScheduleManagerError) in
                completion(.error(error))
            }
        }
    }
}

private extension ScheduleManager {
    func encode(_ schedule: Schedule, storeAt url: URL) throws {
        let jsonEncoder = ComedyFestivalJSONEncoder()
        let data = try jsonEncoder.encode(schedule)
        try data.write(to: url, options: .atomicWrite)
    }
    
    func schedule(from shows: [Show]) throws -> Schedule {
        guard let festivalStartDate = festivalStartDate() else {
            throw ScheduleManagerError.cannotCreateFestivalStartDate
        }
        let groupDateFormatter = DateFormatter()
        groupDateFormatter.dateFormat = "yyyy-MM-dd"
        groupDateFormatter.timeZone = TimeZone(abbreviation: "Europe/Copenhagen")
        // Map of [Date: [Location: [Show]]]
        var rawSchedule: [String: [Location.Name: [Show]]] = [:]
        for show in shows {
            // One show have been added before the actual festival start.
            // We'll filter this by ensuring the date is past the start of the festival.
            guard show.date.timeIntervalSince1970 >= festivalStartDate.timeIntervalSince1970 else { continue }
            let groupDate = groupDateFormatter.string(from: show.date)
            var rawLocation = rawSchedule[groupDate] ?? [:]
            let rawShows = rawLocation[show.locationName] ?? []
            rawLocation[show.locationName] = rawShows + [show]
            rawSchedule[groupDate] = rawLocation
        }
        // Sort shows.
        for (date, showsForLocation) in rawSchedule {
            for (locationName, shows) in showsForLocation {
                rawSchedule[date]?[locationName] = shows.sorted(by: { aShow, bShow in
                    return aShow.date.timeIntervalSince1970 < bShow.date.timeIntervalSince1970
                })
            }
        }
        // Map from raw representation to entities.
        let calendar = Calendar(identifier: .gregorian)
        let days: [Day] = rawSchedule.flatMap { arg in
            let rawDate = arg.key
            let rawLocations = arg.value
            guard let date = groupDateFormatter.date(from: rawDate) else { return nil }
            // A festival day starts at six in the morning and ends at six in the morning the next day.
            var comps = calendar.dateComponents([ .era, .year, .month, .day ], from: date)
            guard let day = comps.day else { return nil }
            comps.hour = 06
            comps.minute = 00
            comps.second = 00
            let tempFestivalDayStartDate = calendar.date(from: comps)
            comps.day = day + 1
            let tempFestivalDayEndDate = calendar.date(from: comps)
            guard
                let festivalDayStartDate = tempFestivalDayStartDate,
                let festivalDayEndDate = tempFestivalDayEndDate else { return nil }
            let locations: [Location] = rawLocations.reduce([]) { result, next in
                return result + [ Location(name: next.key, shows: next.value) ]
            }.sorted(by: { aLocation, bLocation in
                return aLocation.priority < bLocation.priority
            })
            return Day(
                festivalDayStartDate: festivalDayStartDate,
                festivalDayEndDate: festivalDayEndDate,
                locations: locations)
        }
        let sortedDays = days.sorted { aDay, bDay in
            aDay.festivalDayStartDate.timeIntervalSince1970 < bDay.festivalDayStartDate.timeIntervalSince1970
        }
        return Schedule(days: sortedDays)
    }
    
    private func festivalStartDate() -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([ .era ], from: Date())
        components.year = 2017
        components.month = 08
        components.day = 31
        components.hour = 00
        components.minute = 00
        components.second = 00
        return calendar.date(from: components)
    }
}

