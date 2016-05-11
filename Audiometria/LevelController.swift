////
////  LevelController.swift
////  Audiometria
////
////  Created by Henrique Valcanaia on 5/6/16.
////  Copyright © 2016 darkshine. All rights reserved.
////
//
//import AVFoundation
//import UIKit
//
//func map(x:NSNumber, inMin:NSNumber, inMax:NSNumber, outMin:NSNumber, outMax:NSNumber) -> NSNumber{
//    return (x.floatValue - inMin.floatValue) * (outMax.floatValue - outMin.floatValue) / (inMax.floatValue - inMin.floatValue) + outMin.floatValue
//}
//
//class LevelController {
//    
//    private static let thresholds = [20.0, 40.0, 60.0]
//    private var recorder: AVAudioRecorder!
//    private var player:AVAudioPlayer!
//    private var peak: Float = -160.0
//    
//    func updateAudioMeter(timer:NSTimer) {
//        if recorder.recording {
//            recorder.updateMeters()
//            let apc0 = recorder.averagePowerForChannel(0)
//            let peak0 = recorder.peakPowerForChannel(0)
//            let mappedValue = map(apc0, inMin: -80, inMax: 100, outMin: 0, outMax: 1)
//            
//            UIView.animateWithDuration(0.15) {
//                self.graphView.setPercentage(mappedValue.doubleValue, animated: true)
//                self.audiometer.setProgress(mappedValue.floatValue, animated: true)
//            }
//            
//            peak = max(peak, peak0)
//            peakLabel.text = "\(peak)"
//            currentLabel.text = "\(apc0)"
//        }
//    }
//    
//    class func colorForNoiseLevel(noiseLevel: Double) -> UIColor {
//        // RGB for red (slowest)
//        let r_red:CGFloat = 1.0
//        let r_green:CGFloat = 20/255.0
//        let r_blue:CGFloat = 44/255.0
//        
//        // RGB for yellow (middle)
//        let y_red:CGFloat = 1.0
//        let y_green:CGFloat = 215/255.0
//        let y_blue:CGFloat = 0.0
//        
//        // RGB for green (fastest)
//        let g_red:CGFloat = 0.0
//        let g_green:CGFloat = 146/255.0
//        let g_blue:CGFloat = 78/255.0
//        
//        let color:UIColor
//        
//        let medianValue = thresholds[1]
//        // between red and yellow
//        //        if (noiseLevel < medianValue) {
//        //            let ratio:Double = Double(index) / Double(locations.count) / 2.0
//        //            let red:CGFloat = r_red + CGFloat(ratio) * CGFloat(y_red - r_red)
//        //            let green:CGFloat = r_green + CGFloat(ratio) * CGFloat(y_green - r_green)
//        //            let blue:CGFloat = r_blue + CGFloat(ratio) * CGFloat(y_blue - r_blue)
//        //            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
//        //        } else {
//        //            // between yellow and green
//        //            let ratio:Double = (Double(index) - Double(locations.count)/2.0) / (Double(locations.count)/2.0)
//        //            let red:CGFloat = y_red + CGFloat(ratio) * CGFloat(g_red - y_red)
//        //            let green:CGFloat = y_green + CGFloat(ratio) * CGFloat(g_green - y_green)
//        //            let blue:CGFloat = y_blue + CGFloat(ratio) * CGFloat(g_blue - y_blue)
//        //            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
//        //        }
//        
//        return color
//    }
//    
//}