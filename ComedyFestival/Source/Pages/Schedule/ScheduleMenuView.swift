//
//  ScheduleMenuView.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UtilitiesKit

class ScheduleMenuView: View {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).sbs_makeView { me in
        me.backgroundColor = UIColor(hex: 0xEE1C24)
        me.showsHorizontalScrollIndicator = false
        let layout = me.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 7
        layout?.minimumInteritemSpacing = 7
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    let selectionIndicatorView = UIView().sbs_makeView { me in
        me.backgroundColor = .white
        me.alpha = 0
    }
    
    private(set) var selectionIndicatorLeadingConstraint: NSLayoutConstraint?
    private(set) var selectionIndicatorWidthConstraint: NSLayoutConstraint?
    
    override func setupView() {
        super.setupView()
        backgroundColor = .white
        addSubview(collectionView)
        addSubview(selectionIndicatorView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        selectionIndicatorLeadingConstraint = selectionIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        selectionIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        selectionIndicatorWidthConstraint = selectionIndicatorView.widthAnchor.constraint(equalToConstant: 0)
        selectionIndicatorView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        selectionIndicatorLeadingConstraint?.isActive = true
        selectionIndicatorWidthConstraint?.isActive = true        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = CGSize(width: 80, height: bounds.height)
    }
}

