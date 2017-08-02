//
//  ScheduleView.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UtilitiesKit
import UIKit

class ScheduleView: View {
    let menuContainerView = UIView().sbs_makeView()
    let pagesContainerView = UIView().sbs_makeView()
    let loadingView = UIView().sbs_makeView { me in
        me.backgroundColor = .white
        me.alpha = 0
    }
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge).sbs_makeView { me in
        me.color = .black
        me.hidesWhenStopped = true
    }
    
    override func setupView() {
        super.setupView()
        backgroundColor = .white
        addSubview(menuContainerView)
        addSubview(pagesContainerView)
        loadingView.addSubview(activityIndicatorView)
        addSubview(loadingView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        menuContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        menuContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        menuContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        menuContainerView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        pagesContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pagesContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        pagesContainerView.topAnchor.constraint(equalTo: menuContainerView.bottomAnchor).isActive = true
        pagesContainerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        loadingView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: menuContainerView.bottomAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
    }
}

