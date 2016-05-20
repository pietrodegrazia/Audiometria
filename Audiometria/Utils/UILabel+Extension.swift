//
//  UILabel+Extension.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/19/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setTextWithFade(text:String, withDuration duration:CFTimeInterval = 0.75) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        
        layer.addAnimation(animation, forKey: "kCATransitionFade")
        self.text = text
    }
    
}