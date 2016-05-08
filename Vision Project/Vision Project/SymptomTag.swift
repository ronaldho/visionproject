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
    
    override init(){
        id = "0";
        color = UIColor();
        name = "";
    }
    
    init(withId id:String, andColor color: UIColor, andName name: String){
        self.id = id;
        self.color = color;
        self.name = name;
    }
    
}
