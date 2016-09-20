//
//  Utils.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/10/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import Foundation

func map(_ x: NSNumber, inMin: NSNumber, inMax: NSNumber, outMin: NSNumber = 0, outMax:NSNumber = 1) -> NSNumber {
//    let a = (x - inMin)
//    let b = (outMax - outMin)
//    let c = (inMax - inMin)
//    return a * b / c + outMin
    return 1
}

func hvprint(_ items: Any..., function: String = #function) {
    print("\(function): \(items)")
}

func ^(lhs: Double, rhs: TimeMeasure) -> Double {
    return pow(lhs, Double(rhs.rawValue))
}

enum TimeMeasure: Int {
    case nanosecond = 0, microsecond = 1, millisecond = 2, second = 3
}

func delay(_ delay: Double, measure: TimeMeasure = .second, queue: DispatchQueue = Queue.main.queue, closure:@escaping ()->()) {
    let timeInNs = delay * (1000^measure)
    let time = DispatchTime.now() + Double(Int64(timeInNs)) / Double(NSEC_PER_SEC)
    
    queue.asyncAfter(deadline: time, execute: closure)
}

protocol ExecutableQueue {
    var queue: DispatchQueue { get }
}

extension ExecutableQueue {
    func execute(_ block: @escaping ()->()) {
        queue.async(execute: block)
    }
}

enum Queue: ExecutableQueue {
    
    case main
    case userInteractive
    case userInitiated
    case utility
    case background
    
    var queue: DispatchQueue {
        switch self {
        case .main:
            return DispatchQueue.main
            
        case .userInteractive:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
            
        case .userInitiated:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
            
        case .utility:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
            
        case .background:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        }
    }
    
}
