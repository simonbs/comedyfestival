//
//  ScheduleShowCollectionViewCell.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 31/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UIKit
import UtilitiesKit

class ScheduleShowCollectionViewCell: CollectionViewCell {
    let imageView = UIImageView().sbs_makeView { me in
        me.backgroundColor = .lightGray
        me.image = #imageLiteral(resourceName: "placeholder")
        me.contentMode = .scaleAspectFill
        me.clipsToBounds = true
    }
    let headlineLabel = UILabel().sbs_makeView { me in
        me.font = .boldSystemFont(ofSize: 14)
        me.numberOfLines = 1
        me.setContentHuggingPriority(.required, for: .vertical)
        me.setContentCompressionResistancePriority(.required, for: .horizontal)
        me.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let subheadlineLabel = UILabel().sbs_makeView { me in
        me.font = .systemFont(ofSize: 14, weight: .regular)
        me.numberOfLines = 1
        me.setContentHuggingPriority(.required, for: .vertical)
        me.setContentCompressionResistancePriority(.required, for: .horizontal)
        me.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    let venueLabel = UILabel().sbs_makeView { me in
        me.font = .systemFont(ofSize: 14, weight: .regular)
        me.numberOfLines = 1
        me.setContentHuggingPriority(.required, for: .vertical)
        me.setContentCompressionResistancePriority(.required, for: .horizontal)
        me.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let dateLabel = UILabel().sbs_makeView { me in
        me.font = .systemFont(ofSize: 14, weight: .medium)
        me.numberOfLines = 1
        me.setContentHuggingPriority(.required, for: .vertical)
        me.setContentCompressionResistancePriority(.required, for: .horizontal)
        me.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let priceLabel = UILabel().sbs_makeView { me in
        me.font = .systemFont(ofSize: 14, weight: .regular)
        me.numberOfLines = 1
        me.setContentHuggingPriority(.required, for: .vertical)
        me.setContentCompressionResistancePriority(.required, for: .horizontal)
        me.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let soldOutLabel = UILabel().sbs_makeView { me in
        me.font = .systemFont(ofSize: 13, weight: .semibold)
        me.numberOfLines = 1
        me.setContentHuggingPriority(.required, for: .vertical)
        me.setContentCompressionResistancePriority(.required, for: .horizontal)
        me.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let buyTicketsButton = UIButton(type: .system).sbs_makeView { me in
        me.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        me.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        me.setTitleColor(.white, for: .normal)
        me.setBackgroundImage(#imageLiteral(resourceName: "buy-tickets-button"), for: .normal)
        me.setContentHuggingPriority(.required, for: .vertical)
        me.setContentCompressionResistancePriority(.required, for: .horizontal)
        me.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    var didPressBuyTickets: (() -> Void)?
    
    override func setupView() {
        super.setupView()
        buyTicketsButton.addTarget(self, action: #selector(buyTicketsButtonPressed), for: .touchUpInside)
        contentView.addSubview(imageView)
        contentView.addSubview(headlineLabel)
        contentView.addSubview(subheadlineLabel)
        contentView.addSubview(venueLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(soldOutLabel)
        contentView.addSubview(buyTicketsButton)
    }
    
    override func setupLayout() {
        super.setupLayout()
        imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        headlineLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: contentView.layoutMargins.left).isActive = true
        headlineLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        headlineLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        
        subheadlineLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: contentView.layoutMargins.left).isActive = true
        subheadlineLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        subheadlineLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor).isActive = true
        subheadlineLabel.bottomAnchor.constraint(lessThanOrEqualTo: venueLabel.topAnchor).isActive = true
        
        venueLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: contentView.layoutMargins.left).isActive = true
        venueLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        venueLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        
        dateLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: contentView.layoutMargins.left).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor).isActive = true
        
        priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: contentView.layoutMargins.left).isActive = true
        priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: soldOutLabel.leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: buyTicketsButton.leadingAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        soldOutLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        soldOutLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        
        buyTicketsButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        buyTicketsButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        didPressBuyTickets = nil
        imageView.image = #imageLiteral(resourceName: "placeholder")
    }
    
    @objc private func buyTicketsButtonPressed() {
        didPressBuyTickets?()
    }
}
