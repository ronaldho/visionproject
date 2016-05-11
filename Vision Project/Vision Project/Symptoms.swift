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
    
    
    func sort(){
        for index in 0...symptoms.count-2{
            var smallest = index;
            for index2 in index+1...symptoms.count-1{
                
                let order = NSCalendar.currentCalendar().compareDate(symptoms[index2].date, toDate:symptoms[smallest].date, toUnitGranularity: .Day);
                if (order == NSComparisonResult.OrderedAscending) {
                    smallest = index2;
                }
            }
            swap(index,index2: smallest);
        }
    }
    
    func swap(index1: Int, index2: Int){
        if (index1 != index2){
            let temp = symptoms[index1];
            symptoms[index1] = symptoms[index2];
            symptoms[index2] = temp;
        }
    }
    
    func toEmailString() -> String {
        var emailString = "";
        
        for symptom in symptoms {
            emailString += symptom.toEmailString();
            emailString += "\n";
        }
        
        return emailString;
    }
}
