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
    
    override init(){
        self.notes = "";
        super.init();
    };
    
    init(withName name:String, andImage image: UIImage?, andCroppedImage croppedImage: UIImage?, andInfo info:String, andNotes notes:String, andId id:String){
        self.notes = notes;
        super.init(withName: name, andImage: image, andCroppedImage: croppedImage, andInfo: info, andId: id);
    }
    
    override func toString() -> String{
        return "My Medication: { Name: \(name), Info : \(info), Notes: \(notes) }";
    }
    
}
