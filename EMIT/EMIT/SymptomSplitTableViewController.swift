//
//  SymptomSplitTableViewController.swift
//  EMIT Project
//
//  Created by Andrew on 12/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomSplitTableViewController: SymptomTableViewController {

    var delegate: SymptomTableDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func editSymptom(cell: SymptomTableViewCell) {
        delegate!.editSymptom(cell);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
