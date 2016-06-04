//
//  TutorialViewController.swift
//  EMIT
//
//  Created by Andrew on 31/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class AlertStyleWarningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func okButtonPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "alertStyleWarningShown");
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
