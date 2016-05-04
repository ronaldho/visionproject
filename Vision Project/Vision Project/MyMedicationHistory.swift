//
//  MyMedicationHistory.swift
//  Vision Project
//
//  Created by Andrew on 3/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MyMedicationHistory: MyMedication {
    var medId: String;
    var version: Int;
    
    override init(){
        medId = "";
        version = 0;
        super.init();
    }
    
    init(withMed med: MyMedication) {
        medId = med.id;
        version = 0;
        super.init(withName: med.name, andImage: med.image, andCroppedImage: med.croppedImage, andInfo: med.info, andNotes: med.notes, andId: "0", andBreakfast: med.breakfast, andLunch: med.lunch, andDinner: med.dinner, andBed: med.bed, andDate: med.date);
    }
    
    init(withName name: String, andImage image: UIImage?, andCroppedImage croppedImage: UIImage?, andInfo info: String, andNotes notes: String, andId id: String, andBreakfast breakfast: Bool, andLunch lunch: Bool, andDinner dinner: Bool, andBed bed: Bool, andDate date: NSDate, andMedId medId: String, andVersion version: Int) {
        
        self.medId = medId;
        self.version = version;
        
        super.init(withName: name, andImage: image, andCroppedImage: croppedImage, andInfo: info, andNotes: notes, andId: id, andBreakfast: breakfast, andLunch: lunch, andDinner: dinner, andBed: bed, andDate: date);
    }
}
