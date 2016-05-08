//
//  MyMedications.swift
//  Vision Project
//
//  Created by Andrew on 29/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class Symptoms: NSObject {

    var symptoms: [Symptom];
    
    override init(){
        self.symptoms = [];
        super.init()
    }
    
    init(symptoms: [Symptom]){
        self.symptoms = symptoms;
        super.init()
    }
}
