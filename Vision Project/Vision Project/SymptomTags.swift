//
//  SymptomTags.swift
//  Vision Project
//
//  Created by Andrew on 7/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomTags: NSObject {

    var tags: [SymptomTag]!;
    
    override init(){
        tags = [];
        tags.append(SymptomTag(withId: "0", andColor: UIColor.redColor(), andName: "Red"));
        tags.append(SymptomTag(withId: "1", andColor: UIColor.orangeColor(), andName: "Orange"));
        tags.append(SymptomTag(withId: "2", andColor: UIColor.yellowColor(), andName: "Yellow"));
        tags.append(SymptomTag(withId: "3", andColor: UIColor.greenColor(), andName: "Green"));
        tags.append(SymptomTag(withId: "4", andColor: UIColor.blueColor(), andName: "Blue"));
        tags.append(SymptomTag(withId: "5", andColor: UIColor.purpleColor(), andName: "Purple"));
    }
}
