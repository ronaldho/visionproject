//
//  MyMedications.swift
//  Vision Project
//
//  Created by Andrew on 29/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MyMedications: NSObject {

    var meds: [MyMedication];
    
    override init(){
        self.meds = [];
        super.init()
    }
    
    init(meds: [MyMedication]){
        self.meds = meds;
        super.init()
    }
}
