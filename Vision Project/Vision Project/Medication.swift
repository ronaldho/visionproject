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
    var id: String;
    var imageUrl: String?;
    var pageUrl: String?;
    
    override init(){
        self.name = "";
        self.id = "0";
        super.init();
    };
    
    init(withName name:String, andImage image: UIImage?, andCroppedImage croppedImage: UIImage?, andId id:String, andImageUrl imageUrl: String?, andPageUrl pageUrl: String?){
        self.name = name;
        self.image = image;
        self.croppedImage = croppedImage;
        self.id = id;
        self.imageUrl = imageUrl;
        self.pageUrl = pageUrl;
        super.init();
    }
    
    func toString() -> String{
        return "Medication: { Name: \(name), Id: \(id) }";
    }
    
}
