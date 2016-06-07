//
//  DiscontinuedTableViewController.swift
//  EMIT Project
//
//  Created by Andrew on 16/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class DiscontinuedTableViewController: AGTableViewController, InputViewDelegate {

    var discontinuedMeds: MyMedications?
    var itemSaved = false;

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navCtrl = segue.destinationViewController as! UINavigationController;
        let mmvc: MyMedicationViewController = navCtrl.viewControllers[0] as! MyMedicationViewController;
        mmvc.med = (sender as! DiscontinuedTableViewCell).med!
        mmvc.newMode = false;
        mmvc.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        let allMeds = MyMedications()
        allMeds.meds = Data.getAllMyMedications()
        discontinuedMeds = MyMedications()
        discontinuedMeds!.meds = allMeds.getDiscontinuedMeds()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = true;
        self.tableView.estimatedRowHeight = 85;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discontinuedMeds!.meds.count;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("EditDiscontinued", sender: tableView.cellForRowAtIndexPath(indexPath))
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiscontinuedCell", forIndexPath: indexPath) as! DiscontinuedTableViewCell

        let med: MyMedication = discontinuedMeds!.meds[indexPath.row];
        
        cell.backgroundColor = UIColor.whiteColor() //EMITTanColor()
        cell.nameLabel.text = med.name
        cell.med = med
        cell.startedDateLabel.text = med.startedDate.dayMonthFormat()
        cell.stoppedDateLabel.text = med.discontinuedDate?.dayMonthFormat()
        
        return cell
    }
}
