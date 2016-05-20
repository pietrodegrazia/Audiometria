//
//  CircleView.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/17/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

//import CoreAnimation
import UIKit

class CircleView: UIView {
//
//    private let circleLayer: CAShapeLayer!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.clearColor()
//        
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2.0, y: frame.size.height/2.0), radius: frame.size.width/2, startAngle: 90, endAngle: CGFloat(M_PI * 2), clockwise: true)
//        
//        circleLayer = CAShapeLayer()
//        circleLayer.path = circlePath.CGPath
//        circleLayer.fillColor = UIColor.clearColor().CGColor
//        circleLayer.strokeColor = UIColor.redColor().CGColor
//        circleLayer.lineWidth = 5.0;
//        
//        // Don't draw the circle initially
//        circleLayer.strokeEnd = 0.0
//        
//        // Add the circleLayer to the view's layer's sublayers
//        layer.addSublayer(circleLayer)
//    }
//    
//    func animateCircle(duration: NSTimeInterval) {
//        // We want to animate the strokeEnd property of the circleLayer
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        
//        // Set the animation duration appropriately
//        animation.duration = duration
//        
//        // Animate from 0 (no circle) to 1 (full circle)
//        animation.fromValue = 0
//        animation.toValue = 1
//        
//        // Do a linear animation (i.e. the speed of the animation stays the same)
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        
//        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
//        // right value when the animation ends.
//        circleLayer.strokeEnd = 1.0
//        
//        // Do the actual animation
//        circleLayer.addAnimation(animation, forKey: "animateCircle")
//    }
//    
}