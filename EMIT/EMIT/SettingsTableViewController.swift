//
//  SettingsTableViewController.swift
//  EMIT
//
//  Created by Andrew on 4/06/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as! SettingsTableViewCell

        if indexPath.row == 0 {
            cell.name!.text = "Medication Alarms"
        } else if indexPath.row == 1 {
            cell.name!.text = "About"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let mavc = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("MedAlarmsVC")
            self.splitViewController!.showDetailViewController(mavc, sender: self)
        } else if indexPath.row == 1 {
            let avc = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("AboutVC")
            self.splitViewController!.showDetailViewController(avc, sender: self)
        }
    }
}
