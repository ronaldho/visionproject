//
//  AGViewController.swift
//  AG Pregnancy
//
//  Created by Andrew on 9/02/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class AGViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.EMITTanColor();
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(AGViewController.adjustForKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(AGViewController.adjustForKeyboard(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func textFieldShouldReturn(field: UITextField) -> Bool{
    //        let nextField = (field as! AGText).nextField
    //
    //        if ((nextField) != nil) {
    //            nextField.becomeFirstResponder()
    //        } else {
    //            field.resignFirstResponder()
    //        }
    //
    //        return true
    //    }
    
    func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        if notification.name == UIKeyboardWillHideNotification {
            scrollView!.contentInset = UIEdgeInsetsZero
        } else {
            scrollView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView!.scrollIndicatorInsets = scrollView!.contentInset
    }
    
}
