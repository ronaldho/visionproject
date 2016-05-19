//
//  DiscontinuedTableViewController.swift
//  Vision Project
//
//  Created by Andrew on 16/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class DiscontinuedTableViewController: UITableViewController, InputViewDelegate {

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return discontinuedMeds!.meds.count;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("EditDiscontinued", sender: tableView.cellForRowAtIndexPath(indexPath))
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiscontinuedCell", forIndexPath: indexPath) as! DiscontinuedTableViewCell

        let med: MyMedication = discontinuedMeds!.meds[indexPath.row];
        
        
        cell.nameLabel.text = med.name
        cell.med = med
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
