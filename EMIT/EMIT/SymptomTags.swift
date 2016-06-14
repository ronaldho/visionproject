//
//  SymptomTags.swift
//  EMIT Project
//
//  Created by Andrew on 7/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomTags: NSObject {

    var tags: [SymptomTag]!;
    var enabledTags: [SymptomTag]!;
    
    
    override init(){
        tags = Data.getAllSymptomTags();
        enabledTags = [];
        for tag in tags {
            if tag.enabled {
                enabledTags.append(tag);
            }
        }
    }
    
    func getSymptomTagFromID(tagID: String) -> SymptomTag? {
        for tag in tags {
            if tag.id == tagID {
                return tag
            }
        }
        return nil
    }
    
    func saveDefaultSymptomTags(){
        let symptomTags: [SymptomTag] = Data.getAllSymptomTags();
        
        if symptomTags.count == 0 {
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.redColor(), andName: "Pain", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.redOrangeColor(), andName: "", andEnabled: false));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.orangeColor(), andName: "Mood", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.orangeYellowColor(), andName: "", andEnabled: false));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.yellowColor(), andName: "Nausea", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.yellowGreenColor(), andName: "", andEnabled: false));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.greenColor(), andName: "Blood Pressure", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.greenBlueColor(), andName: "", andEnabled: false));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.blueColor(), andName: "Blood Sugars", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.bluePurpleColor(), andName: "", andEnabled: false));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.purpleColor(), andName: "Diarrhea", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.purpleRedColor(), andName: "", andEnabled: false));
            
        }
    }
}
