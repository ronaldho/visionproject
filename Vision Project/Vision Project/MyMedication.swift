//
//  MyMedication.swift
//  Vision Project
//
//  Created by Andrew on 21/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MyMedication: Medication {
    var notes: String;
    var breakfast: Bool;
    var lunch: Bool;
    var dinner: Bool;
    var bed: Bool;
    var date: NSDate;
    
    override init(){
        let staticDates = StaticDates();
        
        self.notes = "";
        breakfast = false;
        lunch = false;
        dinner = false;
        bed = false;
        date = staticDates.defaultDate;
        super.init();
    };
    
    init(withName name: String, andImage image: UIImage?, andCroppedImage croppedImage: UIImage?, andInfo info: String, andNotes notes: String, andId id: String, andBreakfast breakfast: Bool, andLunch lunch: Bool, andDinner dinner:Bool, andBed bed: Bool, andDate date: NSDate){
        self.notes = notes;
        self.breakfast = breakfast;
        self.lunch = lunch;
        self.dinner = dinner;
        self.bed = bed;
        self.date = date;
        super.init(withName: name, andImage: image, andCroppedImage: croppedImage, andInfo: info, andId: id);
    }
    
    override func toString() -> String{
        return "My Medication: { Name: \(name), Info : \(info), Notes: \(notes) }";
    }
    
}
