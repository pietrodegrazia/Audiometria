//
//  NSDate+Extensions.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/10/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import Foundation

extension NSDate {
    
    func toStringWithFormat(format:String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        
        return formatter.stringFromDate(self)
    }
    
}

