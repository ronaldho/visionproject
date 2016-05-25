//
//  MailSender.swift
//  EMIT Project
//
//  Created by Andrew on 8/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import Foundation
import MessageUI

class MailSender: NSObject, MFMailComposeViewControllerDelegate {
    
    let parentVC: UIViewController;
    
    init(parentVC: UIViewController) {
        self.parentVC = parentVC;
        super.init();
    }
    
    func anyMailAvailable() -> Bool {
        if (gmailInstalled() || MFMailComposeViewController.canSendMail()){
            return true;
        } else {
            return false;
        }
    }
    
    func send(title: String, messageBody: String, toRecipents: [String]) {
        if MFMailComposeViewController.canSendMail() {
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(title)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            parentVC.presentViewController(mc, animated: true, completion: nil)
        } else {
            print("No email account found.")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
        didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            switch result.rawValue {
            case MFMailComposeResultCancelled.rawValue: print("Mail Cancelled")
            case MFMailComposeResultSaved.rawValue: print("Mail Saved")
            case MFMailComposeResultSent.rawValue: print("Mail Sent")
            case MFMailComposeResultFailed.rawValue: print("Mail Failed")
            default: break
            }
            parentVC.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func gmailInstalled() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "googlegmail:///")!);
    }
}