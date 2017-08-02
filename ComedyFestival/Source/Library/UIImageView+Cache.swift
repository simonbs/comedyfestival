//
//  UIImageView+Cache.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 31/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    func sbs_setImage(with url: URL, placeholderImage: UIImage? = nil) {
        sd_setImage(with: url, placeholderImage: placeholderImage) { newImage, _, cacheType, _ in
            if cacheType == .none {
                UIView.transition(with: self, duration: 0.3, options: [ .transitionCrossDissolve ], animations: {
                    self.image = newImage
                }, completion: nil)
            } else {
                self.image = newImage
            }
        }
    }
}
