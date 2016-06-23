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
    
    func countCurrentMedsAtTime(time: TimeOfDay) -> Int{
        var count = 0;
        for med in self.getCurrentMeds() {
            switch (time){
            case .Breakfast:
                if med.breakfast {
                    count += 1
                }
            case .Lunch:
                if med.lunch {
                    count += 1
                }
            case .Dinner:
                if med.dinner {
                    count += 1
                }
            case .Bed:
                if med.bed {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    func currentMedsAtTime(time: TimeOfDay) -> [MyMedication] {
        var filteredMeds: [MyMedication] = [];
        for med in self.getCurrentMeds() {
            switch (time){
            case .Breakfast:
                if med.breakfast {
                    filteredMeds.append(med)
                }
            case .Lunch:
                if med.lunch {
                    filteredMeds.append(med)
                }
            case .Dinner:
                if med.dinner {
                    filteredMeds.append(med)
                }
            case .Bed:
                if med.bed {
                    filteredMeds.append(med)
                }
            }
        }
        
        return filteredMeds
    }
    
    func sortAlphabetically(){
        meds.sortInPlace { $0.name < $1.name }
    }
    
    class func timeFirstSort(meds: [MyMedication], time: TimeOfDay) -> [MyMedication]{
        var taken: [MyMedication] = []
        var notTaken: [MyMedication] = []
        for med in meds {
            if med.isTakenAtTime(time) {
                taken.append(med)
            } else {
                notTaken.append(med)
            }
        }
        return taken + notTaken
    }
    
    func countTakenAtTime(time: TimeOfDay) -> Int {
        var count = 0
        for med in meds {
            if med.isTakenAtTime(time) {
                count += 1
            }
        }
        return count
    }
    
    func toShareString() -> String {
        var shareString = "";
        
        for med in meds {
            shareString += med.toShareString();
            shareString += "\n";
        }
        
        return shareString;
    }
    
    func toHTMLTable() -> String {
        var htmlMedTableString = "<tr><th>Medication</th><th>Instructions</th></tr>\n"
        
        for med in self.meds {
            htmlMedTableString += med.toHTMLTableRowString()
//            var timeOfDay = false
//            var medTimes = "Taken at "
//            if (med.breakfast) {
//                timeOfDay = true
//                medTimes += "breakfast"
//            }
//            if med.lunch {
//                if timeOfDay {
//                    medTimes += ", "
//                }
//                medTimes += "lunch"
//                timeOfDay = true
//            }
//            if med.dinner {
//                if timeOfDay {
//                    medTimes += ", "
//                }
//                medTimes += "dinner"
//                timeOfDay = true
//            }
//            if med.bed {
//                if timeOfDay {
//                    medTimes += ", "
//                }
//                medTimes += "bed"
//                timeOfDay = true
//            }
//            var medInstructions = ""
//            if timeOfDay {
//                medInstructions += "<p>" + medTimes + "</p>"
//            }
//            
        }
        
        let htmlStyle = "<style> table, th, td {" +
            "text-align: left; " +
            "vertical-align: top; " +
            "border: 1px solid black; " +
            "border-collapse: collapse; " +
            "} " +
            "p { " +
            "padding: 0; " +
            "margin: 0; " +
            "}" +
            "td, th { " +
            "padding: 2px 6px; " +
            "}" +
        "</style>";
        
        return "<html>\(htmlStyle)<body><table>\(htmlMedTableString)</table></body></html>"
    }
}
