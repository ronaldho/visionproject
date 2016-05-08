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
        super.init(withName: med.name, andImage: med.image, andCroppedImage: med.croppedImage, andInfo: med.info, andInstructions: med.instructions, andId: "0", andBreakfast: med.breakfast, andLunch: med.lunch, andDinner: med.dinner, andBed: med.bed, andDate: med.date, andDiscontinued: med.discontinued);
    }
    
    init(withName name: String, andImage image: UIImage?, andCroppedImage croppedImage: UIImage?, andInfo info: String, andInstructions instructions: String, andId id: String, andBreakfast breakfast: Bool, andLunch lunch: Bool, andDinner dinner: Bool, andBed bed: Bool, andDate date: NSDate, andDiscontinued discontinued: Bool, andMedId medId: String, andVersion version: Int) {
        
        self.medId = medId;
        self.version = version;
        
        super.init(withName: name, andImage: image, andCroppedImage: croppedImage, andInfo: info, andInstructions: instructions, andId: id, andBreakfast: breakfast, andLunch: lunch, andDinner: dinner, andBed: bed, andDate: date, andDiscontinued: discontinued);
    }
}
