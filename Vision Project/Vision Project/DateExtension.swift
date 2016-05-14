//
//  DateExtension.swift
//  EMIT
//
//  Created by Andrew on 8/02/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import Foundation
import UIKit

extension NSDate{
    func monthYearFormat() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM y";
        
        return dateFormatter.stringFromDate(self);
    }
    
    func sameDate(dateToCompareWith: NSDate) -> Bool {
        return NSCalendar.currentCalendar().compareDate(self, toDate:dateToCompareWith, toUnitGranularity: .Day) == NSComparisonResult.OrderedSame;
    }
}