//
//  Medication.swift
//  Vision Project
//
//  Created by Andrew on 21/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class Medication: NSObject {
    var name: String;
    var image: UIImage?;
    var croppedImage: UIImage?;
    var info: String;
    
    override init(){
        self.name = "";
        self.info = "";
        super.init();
    };
    
    init(withName name:String, andImage image: UIImage?, andCroppedImage croppedImage: UIImage?, andInfo info:String){
        self.name = name;
        self.image = image;
        self.croppedImage = croppedImage;
        self.info = info;
        super.init();
    }
    
    func toString() -> String{
        return "Medication: { Name: \(name), Info : \(info) }";
    }
    
}
