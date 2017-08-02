//
//  ScheduleShowsView.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UtilitiesKit

class ScheduleShowsView: View {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).sbs_makeView { me in
        me.backgroundColor = .white
        me.showsVerticalScrollIndicator = false
        let flowLayout = me.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.scrollDirection = .vertical
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.sectionInset = .zero
    }
    
    override func setupView() {
        super.setupView()
        backgroundColor = .white
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: bounds.width, height: 110)
        flowLayout?.headerReferenceSize = CGSize(width: bounds.width, height: 48)
        flowLayout?.sectionHeadersPinToVisibleBounds = true
    }
}

