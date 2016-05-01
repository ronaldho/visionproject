//
//  MyMedicationsTableViewController.swift
//  Vision Project
//
//  Created by Andrew on 26/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

protocol FilterCellDelegate {
    func filterMedList(time: String);
}

protocol MyMedicationCellDelegate {
    
}

protocol InputViewDelegate {
//    var itemToScrollToId: String? {get set};
//    func autoscroll();
}

class MyMedicationsTableViewController: UITableViewController, FilterCellDelegate, MyMedicationCellDelegate {

    var myMedications: MyMedications = MyMedications();
    
    func filterMedList(time: String){
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor.visionDarkGreenColor();
        self.tableView.allowsSelection = false;
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.backgroundColor = UIColor.visionTanColor();
        
        myMedications.meds = Data.getAllMyMedications();
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + myMedications.meds.count;
        //Add 1 for filter header
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! FilterTableViewCell;
            cell.delegate = self;
            
            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyMedicationCell", forIndexPath: indexPath) as! MyMedicationTableViewCell;
            cell.delegate = self;
            let med = myMedications.meds[indexPath.row - 1];
            cell.myMedication = med;
            cell.medName.text = med.name;
            cell.medInfo.text = med.info;
            
            if (med.breakfast){
                cell.breakfastImage.image = UIImage(named: "blueCircle");
            } else {
                cell.breakfastImage.image = UIImage(named: "lightGreyCircle")
            }
            if (med.lunch){
                cell.lunchImage.image = UIImage(named: "blueCircle");
            } else {
                cell.lunchImage.image = UIImage(named: "lightGreyCircle")
            }
            if (med.dinner){
                cell.dinnerImage.image = UIImage(named: "blueCircle");
            } else {
                cell.dinnerImage.image = UIImage(named: "lightGreyCircle")
            }
            if (med.bed){
                cell.bedImage.image = UIImage(named: "blueCircle");
            } else {
                cell.bedImage.image = UIImage(named: "lightGreyCircle")
            }
            
            
            return cell
        }

       
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
