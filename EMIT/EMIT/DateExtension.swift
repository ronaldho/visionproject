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
    
    func dayMonthFormat() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMMM";
        
        return dateFormatter.stringFromDate(self);
    }
    
    func sameDate(dateToCompareWith: NSDate) -> Bool {
        return NSCalendar.currentCalendar().compareDate(self, toDate:dateToCompareWith, toUnitGranularity: .Day) == NSComparisonResult.OrderedSame;
    }
    
    static func getMonthFromMonth(month: NSDate, monthsToIncreaseBy: Int) -> NSDate{
        let nsCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let dateComponents = NSDateComponents()
        dateComponents.month = monthsToIncreaseBy
        
        let newMonthComponent = nsCalendar.dateByAddingComponents(dateComponents, toDate: month, options: [])!
        let components = nsCalendar.components([.Year, .Month], fromDate: newMonthComponent);
        
        return nsCalendar.dateFromComponents(components)!
    }
    
    static func getFirstDayOfMonth(date: NSDate) -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components([.Year, .Month], fromDate: date)
        let startOfMonth = calendar.dateFromComponents(components)!
        
        return startOfMonth;
    }
    
    static func getTimeOfDay(hour: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.setValue(hour, forComponent: NSCalendarUnit.Hour)
        let timeOfDay = calendar.dateFromComponents(components)!
        
        return timeOfDay;
    }
    
    func getTimeFormat() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"; // 2:00 PM
        
        return dateFormatter.stringFromDate(self);
    }
}