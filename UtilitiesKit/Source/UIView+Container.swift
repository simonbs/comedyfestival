//
//  UIView+Container.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    func sbs_replaceContainedView(with view: UIView) {
        subviews.forEach { $0.removeFromSuperview() }
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addConstraint(view.leadingAnchor.constraint(equalTo: leadingAnchor))
        addConstraint(view.trailingAnchor.constraint(equalTo: trailingAnchor))
        addConstraint(view.topAnchor.constraint(equalTo: topAnchor))
        addConstraint(view.bottomAnchor.constraint(equalTo: bottomAnchor))
    }
}
