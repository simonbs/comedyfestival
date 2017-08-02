//
//  ScheduleLocationHeaderReusableView.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 31/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UIKit
import UtilitiesKit

class ScheduleLocationHeaderReusableView: CollectionReusableView {
    let titleLabel = UILabel().sbs_makeView { me in
        me.font = .systemFont(ofSize: 26, weight: .bold)
        me.textColor = .black
        me.numberOfLines = 1
    }
    private let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).sbs_makeView()
    
    override func setupView() {
        super.setupView()
        addSubview(backgroundView)
        addSubview(titleLabel)
    }
    
    override func setupLayout() {
        super.setupLayout()
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
