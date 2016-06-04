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
    
//    class func EMITTanColor() -> UIColor {
//        return UIColor(red: 239/255, green: 234/255, blue: 219/255, alpha: 1.0)
//    }
    
    class func EMITLightGreyColor() -> UIColor {
        return UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0)
    }
    
    class func EMITMediumGreyColor() -> UIColor {
        return UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
    }
    
    class func EMITDarkGreyColor() -> UIColor {
        return UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    }
    
//    class func EMITDarkGreenColor() -> UIColor {
//        return UIColor(red: 47/255, green: 92/255, blue: 29/255, alpha: 1.0)
//    }
//    //#2F5C1D
        class func EMITDarkGreenColor() -> UIColor {
            return UIColor(red: 61/255, green: 119/255, blue: 97/255, alpha: 1.0)
        }
    
//    class func EMITLightGreenColor() -> UIColor {
//        return UIColor(red: 98/255, green: 169/255, blue: 69/255, alpha: 1.0)
//    }

    class func EMITLightGreenColor() -> UIColor {
        return UIColor(red: 136/255, green: 193/255, blue: 2/255, alpha: 1.0)
    }
    
    class func EMITBlueColor() -> UIColor {
        return UIColor(red: 22/255, green: 70/255, blue: 143/255, alpha: 1.0)
    }
    //#16468F
    
    class func EMITPurpleColor() -> UIColor {
        return UIColor(red: 155/255, green: 20/255, blue: 89/255, alpha: 1.0)
    }
    //#9B1459
    
    class func EMITDarkYellowColor() -> UIColor {
        return UIColor(red: 195/255, green: 159/255, blue: 60/255, alpha: 1.0)
    }
    //#C39F3C
    
//    class func EMITRedColor() -> UIColor {
//        return UIColor(red: 195/255, green: 64/255, blue: 50/255, alpha: 1.0)
//    }
//    //#C34032
    
    class func EMITRedColor() -> UIColor {
        return UIColor(red: 254/255, green: 86/255, blue: 20/255, alpha: 1.0)
    }
    
    class func EMITOrangeColor() -> UIColor {
        return UIColor(red: 252/255, green: 139/255, blue: 0/255, alpha: 1.0)
    }
    
    class func EMITYellowColor() -> UIColor {
        return UIColor(red: 253/255, green: 211/255, blue: 1/255, alpha: 1.0)
    }
    
    class func mailBlueColor() -> UIColor {
        return UIColor(red: 30/255, green: 90/255, blue: 239/255, alpha: 1.0)
    }
    //#1E5AEF
    
    class func gmailRedColor() -> UIColor {
        return UIColor(red: 234/255, green: 0/255, blue: 0/255, alpha: 1.0)
    }
    //#EA0000
    
    class func lightLightGrayColor() -> UIColor {
        return UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0)
    }
    //#DDDDDD
    
    class func redOrangeColor() -> UIColor {
        return UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1.0)
    }
    //#FF4500
    
    class func orangeYellowColor() -> UIColor {
        return UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1.0)
    }
    //#FFA500
    
    class func yellowGreenColor() -> UIColor {
        return UIColor(red: 127/255, green: 255/255, blue: 0/255, alpha: 1.0)
    }
    //#
    
    class func greenBlueColor() -> UIColor {
        return UIColor(red: 64/255, green: 224/255, blue: 208/255, alpha: 1.0)
    }
    //#
    
    class func bluePurpleColor() -> UIColor {
        return UIColor(red: 106/255, green: 90/255, blue: 205/255, alpha: 1.0)
    }
    //#
    
    class func purpleRedColor() -> UIColor {
        return UIColor(red: 208/255, green: 32/255, blue: 144/255, alpha: 1.0)
    }
    //#D02090
    
    
    
    class func moonColor() -> UIColor {
        return UIColor(red: 22/255, green: 70/255, blue: 143/255, alpha: 1.0)
    }
    //#16468f
    
    class func sunsetColor() -> UIColor {
        return UIColor(red: 254/255, green: 86/255, blue: 20/255, alpha: 1.0)
    }
    //#fe5614
    
    class func noonColor() -> UIColor {
        return UIColor(red: 253/255, green: 211/255, blue: 1/255, alpha: 1.0)
    }
    //#fdd301
    
    class func morningColor() -> UIColor {
        return UIColor(red: 252/255, green: 139/255, blue: 0/255, alpha: 1.0)
    }
    //#fc8b00
    
    
    
    
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