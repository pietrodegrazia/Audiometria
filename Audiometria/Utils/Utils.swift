//
//  Utils.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/10/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import Foundation

func map(x:NSNumber, inMin:NSNumber, inMax:NSNumber, outMin:NSNumber = 0, outMax:NSNumber = 1) -> NSNumber {
    return (x.floatValue - inMin.floatValue) * (outMax.floatValue - outMin.floatValue) / (inMax.floatValue - inMin.floatValue) + outMin.floatValue
}

func hvprint(items:Any..., function:String = #function) {
    print("\(function): \(items)")
}

func ^(lhs:Double, rhs:TimeMeasure) -> Double {
    return pow(lhs, Double(rhs.rawValue))
}

enum TimeMeasure:Int {
    case Nanosecond = 0, Microsecond = 1, Millisecond = 2, Second = 3
}

func delay(delay: Double, measure:TimeMeasure = .Second, queue:dispatch_queue_t = Queue.Main.queue, closure:()->()) {
    let timeInNs = delay * (1000^measure)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(timeInNs))
    
    dispatch_after(time, queue, closure)
}

protocol ExecutableQueue {
    var queue: dispatch_queue_t { get }
}

extension ExecutableQueue {
    func execute(block: dispatch_block_t) {
        dispatch_async(queue, block)
    }
}

enum Queue: ExecutableQueue {
    
    case Main
    case UserInteractive
    case UserInitiated
    case Utility
    case Background
    
    var queue: dispatch_queue_t {
        switch self {
        case .Main:
            return dispatch_get_main_queue()
            
        case .UserInteractive:
            return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
            
        case .UserInitiated:
            return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            
        case .Utility:
            return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
            
        case .Background:
            return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        }
    }
    
}