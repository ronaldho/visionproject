//
//  MyMedication.swift
//  EMIT Project
//
//  Created by Andrew on 21/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MyMedication: Medication {
    var instructions: String;
    var breakfast: Bool;
    var lunch: Bool;
    var dinner: Bool;
    var bed: Bool;
    var date: NSDate;
    var discontinued: Bool;
    var startedDate: NSDate;
    var discontinuedDate: NSDate?;
    
    override init(){
        let staticDates = StaticDates();
        
        self.instructions = "";
        breakfast = false;
        lunch = false;
        dinner = false;
        bed = false;
        discontinued = false;
        date = staticDates.defaultDate
        startedDate = NSDate()
        super.init();
    };
    
    init(withName name: String, andImage image: UIImage?, andCroppedImage croppedImage: UIImage?, andInstructions instructions: String, andId id: String, andBreakfast breakfast: Bool, andLunch lunch: Bool, andDinner dinner:Bool, andBed bed: Bool, andDate date: NSDate, andDiscontinued discontinued: Bool, andStartedDate startedDate: NSDate, andDiscontinuedDate discontinuedDate: NSDate?, andPageUrl pageUrl: String?){
        self.instructions = instructions;
        self.breakfast = breakfast;
        self.lunch = lunch;
        self.dinner = dinner;
        self.bed = bed;
        self.date = date;
        self.discontinued = discontinued;
        self.startedDate = startedDate
        self.discontinuedDate = discontinuedDate
        
        super.init(withName: name, andImage: image, andCroppedImage: croppedImage, andId: id, andImageUrl: nil, andPageUrl: pageUrl);
    }
    
    func timesOfDayToString() -> String {
        var times = ""
        
        if breakfast {
            times = "Breakfast"
        }
        if lunch {
            if times != "" {
                times += ", "
            }
            times += "Lunch"
        }
        if dinner {
            if times != "" {
                times += ", "
            }
            times += "Dinner"
        }
        if bed {
            if times != "" {
                times += ", "
            }
            times += "Bed"
        }
        
        return "Taken at: " + times
    }
    
    func isTakenAtTime(time: TimeOfDay) -> Bool {
        switch (time) {
        case .Breakfast:
            if self.breakfast {
                return true
            }
        case .Lunch:
            if self.lunch {
                return true
            }
        case .Dinner:
            if self.dinner {
                return true
            }
        case .Bed:
            if self.bed {
                return true
           }
        }
        return false
    }
    
    override func toString() -> String{
        return "My Medication: { Name: \(name), Notes: \(instructions) }";
    }
    
    func toHTMLTableRowString() -> String {
        let nameCell = "<td>\(self.name)</td>"
        let timeOfDayP = "<p>\(self.timesOfDayToString())\n</p>"
        let instructionP = "<p>\(self.instructions)</p>"
        let instructionsCell = "<td>\(timeOfDayP)\(instructionP)</td>"
        return "<tr>\(nameCell)\(instructionsCell)</tr>\n"
    }
    
    func toShareString() -> String {
        return "\(self.name)\n\t\(self.timesOfDayToString())\n\t\(self.instructions)\n"
    }
    
}
