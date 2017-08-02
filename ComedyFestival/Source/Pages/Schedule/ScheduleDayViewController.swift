//
//  ScheduleDayViewController.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 01/08/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import ComedyFestivalKit

class ScheduleDayViewController: ScheduleShowsViewController {
    let pageIndex: Int
    
    init(pageIndex: Int, day: Day) {
        self.pageIndex = pageIndex
        super.init(locations: day.locations)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
