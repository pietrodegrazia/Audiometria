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