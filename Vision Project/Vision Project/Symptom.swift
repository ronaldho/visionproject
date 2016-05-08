//
//  Symptom.swift
//  Vision Project
//
//  Created by Andrew on 4/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class Symptom: NSObject {
    var id: String!;
    var date: NSDate!;
    var text: String!;
    var tagIDs: [String]!;
    var image: UIImage?;
    var croppedImage: UIImage?;
    
    override init(){
        id = "0"
        date = NSDate();
        text = "";
        tagIDs = [];
    }
    
    init(withId id:String, andDate date:NSDate, andText text:String, andTagIDs tagIDs: [String], andImage image: UIImage?, andCroppedImage croppedImage: UIImage?){
        self.id = id;
        self.date = date;
        self.text = text;
        self.tagIDs = tagIDs;
        self.image = image;
        self.croppedImage = croppedImage;
    }
    
    func getDateString() -> String{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d";
        
        return dateFormatter.stringFromDate(date);
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
    
    func tagIDsToString() -> String{
        var stringOutput: String = "";
        var count = 0;
        for tagID in tagIDs {
            if (count != 0){
                stringOutput = stringOutput + "|"
            }
            stringOutput = stringOutput + tagID
            count++;
        }
        return stringOutput;
    }
    
    func tagIDsFromString(tagString: String){
        self.tagIDs = tagString.componentsSeparatedByString("|");
    }
    
    func hasTagID(tagIDinput: String) -> Bool {
        for tagID in tagIDs {
            if (tagID == tagIDinput){
                return true;
            }
        }
        return false;
    }
    
}
