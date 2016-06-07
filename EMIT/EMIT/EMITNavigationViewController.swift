//
//  EMITNavigationViewController.swift
//  EMIT
//
//  Created by Andrew on 25/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class EMITNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.barTintColor = UIColor.EMITBlueColor();
        self.navigationBar.barStyle = UIBarStyle.Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
