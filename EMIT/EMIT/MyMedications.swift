//
//  MyMedications.swift
//  EMIT Project
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
    
    func getCurrentMeds() -> [MyMedication]{
        var currentMeds: [MyMedication] = [];
        for med in meds{
            if (!med.discontinued){
                currentMeds.append(med);
            }
        }
        return currentMeds;
    }
    
    func getDiscontinuedMeds() -> [MyMedication]{
        var discontinuedMeds: [MyMedication] = [];
        for med in meds{
            if (med.discontinued){
                discontinuedMeds.append(med);
            }
        }
        return discontinuedMeds;
    }
    
    func sortAlphabetically(){
        meds.sortInPlace { $0.name < $1.name }
    }
}
