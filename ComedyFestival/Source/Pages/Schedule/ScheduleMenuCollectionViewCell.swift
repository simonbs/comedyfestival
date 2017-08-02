//
//  MenuCollectionViewCell.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 30/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UIKit
import UtilitiesKit

class ScheduleMenuCollectionViewCell: CollectionViewCell {
    let titleLabel = UILabel().sbs_makeView { me in
        me.font = .systemFont(ofSize: 17, weight: .medium)
        me.textColor = .white
        me.setContentHuggingPriority(.required, for: .horizontal)
        me.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override func setupView() {
        super.setupView()
        contentView.addSubview(titleLabel)
    }
    
    override func setupLayout() {
        super.setupLayout()
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
