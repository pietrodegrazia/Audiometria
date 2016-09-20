//
//  CABasicAnimation+Extensions.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/19/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import QuartzCore

extension CALayer {
    
    func animateToBackgroundColor(_ color: CGColor, withDuration duration: CFTimeInterval = 0.1) {
        let animation = CABasicAnimation.setBackgroundColor(color, forLayer: self, withDuration: duration)
        add(animation, forKey: nil)
    }
    
}

extension CABasicAnimation {
    
    static func setBackgroundColor(_ color: CGColor, forLayer layer: CALayer, withDuration duration: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        layer.backgroundColor = color
        animation.toValue = color
        animation.duration = duration
        
        return animation
    }
    
}

extension CATransition {
    
    static func fadeTransitionWithDuration(_ duration:CFTimeInterval = 0.2, timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)) -> CATransition {
        let transition = CATransition()
        transition.timingFunction = timingFunction
        transition.type = kCATransitionFade
        transition.duration = duration
        
        return transition
    }
    
}
