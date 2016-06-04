//
//  TutorialViewController.swift
//  EMIT
//
//  Created by Andrew on 31/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.EMITLightGreyColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func okButtonPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "tutorialShown");
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
