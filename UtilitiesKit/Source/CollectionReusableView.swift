//
//  CollectionReusableView.swift
//  UtilitiesKit
//
//  Created by Simon Støvring on 31/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UIKit

open class CollectionReusableView: UICollectionReusableView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupView() { }
    
    open func setupLayout() { }
}

