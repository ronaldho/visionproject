
//
//  Medications.swift
//  EMIT Project
//
//  Created by Andrew on 8/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import Foundation

class Medications: NSObject {
    var medications: [Medication];
    
    override init(){
        medications = [];
        //medications.append(Medication(withName: "Tacrolimus", andImage: nil, andCroppedImage: nil, andInfo: "", andId: ""));
    }
    
    func sortAlphabetically(){
        medications.sortInPlace { $0.name < $1.name }
    }
}
