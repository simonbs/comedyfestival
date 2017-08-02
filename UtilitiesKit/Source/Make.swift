//
//  Make.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UIKit

public protocol Make {}

public extension Make where Self: Any {
    func sbs_make(make: ((Self) -> Void)? = nil) -> Self {
        make?(self)
        return self
    }
}

public extension Make where Self: UIView {
    func sbs_makeView(make: ((Self) -> Void)? = nil) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return sbs_make(make: make)
    }
}

extension NSObject: Make {}
