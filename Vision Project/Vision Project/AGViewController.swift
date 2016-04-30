//
//  ThriveViewController.swift
//  Thrive Pregnancy
//
//  Created by Andrew on 9/02/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class AGViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 250/255, green: 200/255, blue: 51/255, alpha: 1);
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "adjustForKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: "adjustForKeyboard:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func textFieldShouldReturn(field: UITextField) -> Bool{
//        let nextField = (field as! ThriveText).nextField
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
