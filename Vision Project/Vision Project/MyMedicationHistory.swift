//
//  MyMedicationHistory.swift
//  Vision Project
//
//  Created by Andrew on 3/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MyMedicationHistory: NSObject {
    var id: String;
    var medId: String;
    var date: NSDate;
    var text: String;
    
    override init(){
        id = "0";
        medId = "0";
        date = NSDate();
        text = "";
        super.init();
    }
    
    init(withId id: String, andMedId medId: String, andDate date: NSDate, andText text: String) {
        self.id = id;
        self.medId = medId;
        self.date = date;
        self.text = text;
    }
}
