//
//  Symptom.swift
//  EMIT Project
//
//  Created by Andrew on 4/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class Symptom: NSObject {
    var id: String!;
    var date: NSDate!;
    var text: String!;
    var symptomTags: [SymptomTag]!;
    var image: UIImage?;
    var croppedImage: UIImage?;
    
    override init(){
        id = "0"
        date = NSDate();
        text = "";
        symptomTags = [];
    }
    
    init(withId id:String, andDate date:NSDate, andText text:String, andSymptomTags symptomTags: [SymptomTag], andImage image: UIImage?, andCroppedImage croppedImage: UIImage?){
        self.id = id;
        self.date = date;
        self.text = text;
        self.symptomTags = symptomTags;
        self.image = image;
        self.croppedImage = croppedImage;
    }
    
    func getDateTimeString() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM d, h:mm a";
        
        return dateFormatter.stringFromDate(date);
    }
    
    func getShortDateTimeString() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, h:mm a"
        
        return dateFormatter.stringFromDate(date)
    }
    
    func symptomTagsToString() -> String{
        var stringOutput: String = "";
        var count = 0;
        for symptomTag in self.symptomTags {
            if (count != 0){
                stringOutput = stringOutput + "|"
            }
            stringOutput = stringOutput + symptomTag.id
            count += 1;
        }
        return stringOutput;
    }
    
    func symptomTagsToNameString() -> String{
        var stringOutput: String = "";
        var count = 0;
        for symptomTag in self.symptomTags {
            if (count != 0){
                stringOutput = stringOutput + ", "
            }
            stringOutput = stringOutput + symptomTag.name
            count += 1;
        }
        return stringOutput;
    }
    
    func symptomTagsFromString(tagString: String){
        let tagIDs = tagString.componentsSeparatedByString("|");
        let symptomTagsClass = SymptomTags()
        if tagIDs[0] != "" {
            for tagID in tagIDs {
                self.symptomTags.append(symptomTagsClass.getSymptomTagFromID(tagID)!)
            }
        }
    }
    
    func hasSymptomTag(symptomTagInput: SymptomTag) -> Bool {
        for symptomTag in self.symptomTags {
            if (symptomTag.id == symptomTagInput.id){
                return true;
            }
        }
        return false;
    }
    
    func toEmailString() -> String {
        return "\(self.date.dayMonthYearFormat()) - (\(self.symptomTagsToNameString())) \(self.text)"
    }
    
    override var description: String {
        return "symptom= {\(self.text), date:\(self.date.dayMonthYearFormat()), tags:\(self.symptomTagsToNameString())}"
    }
    
}
