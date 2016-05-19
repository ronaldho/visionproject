//
//  UIColorExtension.swift
//  EMIT
//
//  Created by Andrew on 8/02/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    class func greyPlaceholderColor() -> UIColor {
        return UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    }
    
    class func greyTextFieldBorderColor() -> UIColor {
        return UIColor.grayColor().colorWithAlphaComponent(0.5)
    }
    
    class func visionTanColor() -> UIColor {
        return UIColor(red: 239/255, green: 234/255, blue: 219/255, alpha: 1.0)
    }
    
    class func visionDarkGreenColor() -> UIColor {
        return UIColor(red: 47/255, green: 92/255, blue: 29/255, alpha: 1.0)
    }
    //#2F5C1D
    
    class func visionLightGreenColor() -> UIColor {
        return UIColor(red: 98/255, green: 169/255, blue: 69/255, alpha: 1.0)
    }
    
    class func visionBlueColor() -> UIColor {
        return UIColor(red: 22/255, green: 70/255, blue: 143/255, alpha: 1.0)
    }
    //#16468F
    
    class func visionPurpleColor() -> UIColor {
        return UIColor(red: 155/255, green: 20/255, blue: 89/255, alpha: 1.0)
    }
    //#9B1459
    
    
    
    class func mailBlueColor() -> UIColor {
        return UIColor(red: 30/255, green: 90/255, blue: 239/255, alpha: 1.0)
    }
    //#1E5AEF
    
    class func gmailRedColor() -> UIColor {
        return UIColor(red: 234/255, green: 0/255, blue: 0/255, alpha: 1.0)
    }
    //#EA0000
    
    class func getColorFromString(colorString: String) -> UIColor {
        let colorArray: [String] = colorString.componentsSeparatedByString("|");
        return UIColor(red: CGFloat(NSNumberFormatter().numberFromString(colorArray[0])!),
                       green: CGFloat(NSNumberFormatter().numberFromString(colorArray[1])!),
                       blue: CGFloat(NSNumberFormatter().numberFromString(colorArray[2])!),
                       alpha: CGFloat(NSNumberFormatter().numberFromString(colorArray[3])!));
    }
    
    func getStringFromColor() -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            let colorString: String = String(r) + "|" + String(g) + "|" + String(b) + "|" + String(a);
            return colorString;
        } else {
            return "";
        }
    }
    
    
}