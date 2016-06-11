//
//  TutorialViewController.swift
//  EMIT
//
//  Created by Andrew on 31/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class AlertStyleWarningViewController: UIViewController {

    @IBOutlet var importantLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var openSettingsButton: UIButton!
    
    @IBAction func openSettingsPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        okButton.hidden = false;
    }
    
    @IBAction func okButtonPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "alertStyleWarningShown");
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
