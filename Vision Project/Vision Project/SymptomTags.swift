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
    
}
