//
//  UIColorExtension.swift
//  Thrive Pregnancy
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
    
    class func thriveRedColor() -> UIColor {
        return UIColor(red: 244/255, green: 122/255, blue: 85/255, alpha: 1.0)
    }
    
    class func thriveYellowColor() -> UIColor {
        return UIColor(red: 255/255, green: 203/255, blue: 0/255, alpha: 1.0)
    }
    
    class func thriveLightYellowColor() -> UIColor {
        return UIColor(red: 255/255, green: 215/255, blue: 102/255, alpha: 1.0)
    }
    
    class func thriveBlueColor() -> UIColor {
        return UIColor(red: 119/255, green: 203/255, blue: 205/255, alpha: 1.0)
    }
}