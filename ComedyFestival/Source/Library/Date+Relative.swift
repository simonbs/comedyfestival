//
//  Date+Relative.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 30/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation

extension Date {
    func sbs_dateForTomorrow() -> Date? {
        return sbs_date(forDeltaDay: 1)
    }
    
    func sbs_dateForYesterday() -> Date? {
        return sbs_date(forDeltaDay: -1)
    }
    
    func sbs_dateForDayBeforeYesterday() -> Date? {
        return sbs_date(forDeltaDay: -2)
    }
    
    func sbs_isTomorrow() -> Bool {
        guard let tomorrow = sbs_dateForTomorrow() else { return false }
        return sbs_isSameDay(as: tomorrow)
    }
    
    func sbs_isToday() -> Bool {
        return sbs_isSameDay(as: Date())
    }
    
    func sbs_isYesterday() -> Bool {
        guard let yesterday = sbs_dateForYesterday() else { return false }
        return sbs_isSameDay(as: yesterday)
    }
    
    func sbs_isWithinAWeek() -> Bool {
        let weekInterval: TimeInterval = 7 * 24 * 3600
        let now = Date()
        let weekIntoTheFuture = now + weekInterval
        return timeIntervalSince1970 < weekIntoTheFuture.timeIntervalSince1970 && timeIntervalSince1970 > now.timeIntervalSince1970
    }
}

private extension Date {
    private func sbs_date(forDeltaDay deltaDay: Int) -> Date? {
        var deltaComponents = DateComponents()
        deltaComponents.day = deltaDay
        return Calendar.current.date(byAdding: deltaComponents, to: Date())
    }
    
    private func sbs_isSameDay(as otherDate: Date) -> Bool {
        let dateComps = sbs_dateComponents(date: self)
        let otherDateComps = sbs_dateComponents(date: otherDate)
        return dateComps.year == otherDateComps.year && dateComps.month == otherDateComps.month && dateComps.day == otherDateComps.day
    }
    
    private func sbs_dateComponents(date: Date) -> DateComponents {
        return Calendar.current.dateComponents([ .day, .month, .year ], from: date)
    }
}
