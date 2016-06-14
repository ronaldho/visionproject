//
//  MedicationDosage.swift
//  EMIT
//
//  Created by Andrew on 11/06/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MedicationDosage: NSObject {
    var id: String;
    var medicationId: String;
    var dosage: String;
    var imageUrl: String?;
    var image: UIImage?;
    var croppedImage: UIImage?;
    
    
    override init(){
        self.id = "0";
        self.medicationId = "0";
        self.dosage = "";
        super.init();
    };
    
    init(withId id: String, andMedicationId medicationId: String, andDosage dosage: String, andImageUrl imageUrl: String?, andImage image: UIImage?, andCroppedImage croppedImage: UIImage?){
        self.id = id;
        self.medicationId = medicationId;
        self.dosage = dosage;
        self.imageUrl = imageUrl;
        self.image = image;
        self.croppedImage = croppedImage;
        super.init();
    }
    
    func toString() -> String{
        return "Medication Dosage: { Dosage: \(dosage), Id: \(id), MedId: \(medicationId) }";
    }

}
