//
//  Utils.swift
//  Disposable
//
//  Created by Laura Grayden on 17/09/2015.
//  Copyright (c) 2015 Lance Apps. All rights reserved.
//

import Foundation

struct Util {
    
    static func removeTimeComponent(date: NSDate) -> NSDate
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let s = dateFormatter.stringFromDate(date)
        
        let newDate = dateFormatter.dateFromString(s)
        
        return newDate!
    }
}


