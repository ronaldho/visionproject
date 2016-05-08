//
//  MyMedication.swift
//  Vision Project
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
    
    override init(){
        let staticDates = StaticDates();
        
        self.instructions = "";
        breakfast = false;
        lunch = false;
        dinner = false;
        bed = false;
        discontinued = false;
        date = staticDates.defaultDate;
        super.init();
    };
    
    init(withName name: String, andImage image: UIImage?, andCroppedImage croppedImage: UIImage?, andInfo info: String, andInstructions instructions: String, andId id: String, andBreakfast breakfast: Bool, andLunch lunch: Bool, andDinner dinner:Bool, andBed bed: Bool, andDate date: NSDate, andDiscontinued discontinued: Bool){
        self.instructions = instructions;
        self.breakfast = breakfast;
        self.lunch = lunch;
        self.dinner = dinner;
        self.bed = bed;
        self.date = date;
        self.discontinued = discontinued;
        
        super.init(withName: name, andImage: image, andCroppedImage: croppedImage, andInfo: info, andId: id);
    }
    
    override func toString() -> String{
        return "My Medication: { Name: \(name), Info : \(info), Notes: \(instructions) }";
    }
    
}
