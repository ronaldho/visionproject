//
//  SymptomTag.swift
//  Vision Project
//
//  Created by Andrew on 4/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomTag: NSObject {
    var id: String;
    var color: UIColor!;
    var name: String;
    var enabled: Bool;
    
    override init(){
        id = "0";
        color = UIColor();
        name = "";
        enabled = true;
    }
    
    init(withId id:String, andColor color: UIColor, andName name: String, andEnabled enabled: Bool){
        self.id = id;
        self.color = color;
        self.name = name;
        self.enabled = enabled;
    }
    
    func toString() -> String {
        return "SymptomTag {id: \(id), name: \(name), color: \(color), enabled: \(enabled)}"
    }
    
}
