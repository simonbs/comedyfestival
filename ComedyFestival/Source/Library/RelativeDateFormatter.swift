//
//  RelativeDateFormatter.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 30/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation

struct RelativeDateFormatter {
    private let showsTime: Bool
    private let weekdayFormatter = DateFormatter().sbs_make { me in
        me.dateFormat = "EEEE"
        me.locale = Locale(identifier: "da_DK")
        me.timeZone = TimeZone(abbreviation: "Europe/Copenhagen")
    }
    private let fullDateFormatter = DateFormatter().sbs_make { me in
        me.dateFormat = "EEE d. LLL"
        me.locale = Locale(identifier: "da_DK")
        me.timeZone = TimeZone(abbreviation: "Europe/Copenhagen")
    }
    private let timeDateFormatter = DateFormatter().sbs_make { me in
        me.dateFormat = "HH:mm"
        me.locale = Locale(identifier: "da_DK")
        me.timeZone = TimeZone(abbreviation: "Europe/Copenhagen")
    }
    
    init(showsTime: Bool) {
        self.showsTime = showsTime
    }
    
    func string(from date: Date) -> String {
        let dateStr: String
        if date.sbs_isTomorrow() {
            dateStr = NSLocalizedString("relativedateformatter.tomorrow", comment: "Relative date for tomorrow")
        } else if date.sbs_isToday() {
            dateStr = NSLocalizedString("relativedateformatter.today", comment: "Relative date for today")
        } else if date.sbs_isYesterday() {
            dateStr = NSLocalizedString("relativedateformatter.yesterday", comment: "Relative date for yesterday")
        } else if date.sbs_isWithinAWeek() {
            dateStr = weekdayFormatter.string(from: date).capitalized
        } else {
            dateStr = fullDateFormatter.string(from: date)
        }
        if showsTime {
            let timeStr = timeDateFormatter.string(from: date)
            return "\(dateStr) \(timeStr)"
        } else {
            return dateStr
        }
    }
}

