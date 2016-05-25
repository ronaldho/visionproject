//
//  NeedInfoHTML.swift
//  Thrive Pregnancy
//
//  Created by Andrew on 5/12/15.
//  Copyright © 2015 Andrew. All rights reserved.
//

import UIKit
import Foundation

class MedPageHTMLViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet var webView: UIWebView! = UIWebView();
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var med: Medication?;
    var myMed: MyMedication?;
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        // Apparently it's important to nil the delegate
        webView.delegate = nil;
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("MyMedFromInfo", sender: sender)
    }

    
    override func viewDidLoad(){
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor.EMITDarkGreenColor();

        
        webView.delegate = self;

        var url: NSURL?
        if med != nil {
            if med!.pageUrl != nil {
                url = NSURL(string: med!.pageUrl!)
            } else {
                print("Error, med.pageUrl is nil")
            }
            
        } else if myMed != nil {
            navTitle.rightBarButtonItem = nil

            if myMed!.pageUrl != nil {
                url = NSURL(string: myMed!.pageUrl!)
            } else {
                print("Error, myMed.pageUrl is nil")
            }
        }
        
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MyMedFromInfo" {
            let navCtrl: UINavigationController = segue.destinationViewController as! UINavigationController
            let mmvc: MyMedicationViewController = (navCtrl.viewControllers[0]) as! MyMedicationViewController
            mmvc.newMode = true
            mmvc.medToAdd = self.med
        }
    }
}
