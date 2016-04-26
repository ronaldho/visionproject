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
    var id: String;
    
    override init(){
        self.name = "";
        self.info = "";
        self.id = "0";
        super.init();
    };
    
    init(withName name:String, andImage image: UIImage?, andCroppedImage croppedImage: UIImage?, andInfo info:String, andId id:String){
        self.name = name;
        self.image = image;
        self.croppedImage = croppedImage;
        self.info = info;
        self.id = id;
        super.init();
    }
    
    func toString() -> String{
        return "Medication: { Name: \(name), Info : \(info), Id: \(id) }";
    }
    
}
