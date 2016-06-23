//
//  SendViewController.swift
//  EMIT Project
//
//  Created by Andrew on 9/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import MessageUI
import UIKit

class SendMedsViewController: AGInputViewController, SymptomTagCellDelegate {
    

    @IBOutlet var sendEmailButton: UIButton!;
    @IBOutlet var sendGmailButton: UIButton!;

    var allMeds: MyMedications!;
    var ms: MailSender?;
    
    @IBAction func onSendPressed(sender: UIButton) {
        ms = MailSender(parentVC: self);
        
        let title = "Symptoms"
        let messageBody = allMeds!.toShareString();
        //let toRecipents = ["foo@bar.com"]
        
        if (sender == self.sendGmailButton){
            let gmailString: String = String("googlegmail:///co?subject=\(title)&body=\(messageBody)");
            let urlString = gmailString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet());
            let gmailURL: NSURL = NSURL(string: urlString!)!;
            
            UIApplication.sharedApplication().openURL(gmailURL);
            
        } else if (sender == self.sendEmailButton) {
            ms?.send(title, messageBody: messageBody, toRecipents: []);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendEmailButton.backgroundColor = UIColor.mailBlueColor();
        
        ms = MailSender(parentVC: self);
        if (ms!.gmailInstalled()){
            sendGmailButton.hidden = false;
            sendGmailButton.backgroundColor = UIColor.gmailRedColor();
        } else {
            sendGmailButton.hidden = true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
