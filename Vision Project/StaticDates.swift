//
//  StaticDates.swift
//  Thrive Pregnancy
//
//  Created by Andrew on 24/11/15.
//  Copyright © 2015 Andrew. All rights reserved.
//

import Foundation

class StaticDates: NSObject {
    
    static let sharedInstance = StaticDates();
    var defaultDate: NSDate;
    
    override init(){
        let components:NSDateComponents = NSDateComponents();
        components.year = 1970;
        
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        
        defaultDate = (calendar?.dateFromComponents(components))!;
    }
    
    static let oneYearFromToday: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(
        .Year, value: 1, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))!
    
    static let yesterday: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(
        .Day, value: -1, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))!
}