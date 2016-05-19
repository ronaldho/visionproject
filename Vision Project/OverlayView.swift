//
//  OverlayView.swift
//  Vision Project
//
//  Created by Andrew on 14/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class OverlayView: UIView {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var textField = UITextField()
    
    class var shared: OverlayView {
        struct Static {
            static let instance: OverlayView = OverlayView()
        }
        return Static.instance
    }
    
    func createOverlay(superview: UIView, text: String) {
        
        overlayView.frame = CGRectMake(0, 0, 80, 80)
        overlayView.center = superview.center
        overlayView.backgroundColor = UIColor(red: 44/256, green: 44/256, blue: 44/256, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        textField.text = text
        textField.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(textField);
        
      
//        let horizontalConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: overlayView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 10)
//        overlayView.addConstraint(horizontalConstraint)
//        
//        let verticalConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: overlayView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 10)
//        overlayView.addConstraint(verticalConstraint)
//        
//        let widthConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: overlayView, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 10)
//        overlayView.addConstraint(widthConstraint)
//        
//        let heightConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: overlayView, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 10)
//        overlayView.addConstraint(heightConstraint)
        
//        if (loading) {
//            activityIndicator.frame = CGRectMake(0, 0, 40, 40)
//            activityIndicator.activityIndicatorViewStyle = .WhiteLarge
//            activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
//            
//            overlayView.addSubview(activityIndicator)
//        }

        superview.addSubview(overlayView)
        
//        activityIndicator.startAnimating()
    }
    
    func hideOverlayView() {
//        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
