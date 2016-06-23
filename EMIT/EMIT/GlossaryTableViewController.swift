//
//  GlossaryTableViewController.swift
//  EMIT Project
//
//  Created by Andrew on 9/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Foundation


class GlossaryTableViewController: AGTableViewController {

    var medications: Medications = Medications();
    
    override func viewWillAppear(animated: Bool){
        medications.medications = Data.getAllMedications();
        medications.sortAlphabetically();
        self.tableView.reloadData()
        
        if medications.medications.count == 0 {
            if Reachability.isConnectedToNetwork() {
                let activityIndicator = UIActivityIndicatorView()
                self.tableView.backgroundView = activityIndicator
                activityIndicator.startAnimating()
                
                MedicationAPI().getMedicationData(withCompletion: {() -> Void in
                    self.medications.medications = Data.getAllMedications();
                    self.medications.sortAlphabetically();
                    self.tableView.reloadData()
                    activityIndicator.stopAnimating()
                    self.tableView.backgroundView = nil
                })
            } else {
                let label = UILabel()
                label.text = "Internet connection required"
                label.textAlignment = .Center
                self.tableView.backgroundView = label
            }
        } else {
            self.tableView.backgroundView = nil
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tableView.backgroundView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = true;
        self.tableView.estimatedRowHeight = 25;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medications.medications.count;
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GlossaryCell", forIndexPath: indexPath) as! GlossaryTableViewCell;
        
        let medication = medications.medications[indexPath.row];
        cell.medication = medication;
        cell.nameLabel.text = medication.name;
        cell.medImageView.image = medication.image;
        cell.backgroundColor = UIColor.whiteColor() //EMITTanColor();

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let navCtrl = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("MedInfoNav") as! UINavigationController
        let htmlvc: MedPageHTMLViewController = navCtrl.viewControllers[0] as! MedPageHTMLViewController;
        htmlvc.med = (tableView.cellForRowAtIndexPath(indexPath) as! GlossaryTableViewCell).medication!
        self.presentViewController(navCtrl, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "MedInfoFromGlossary"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let htmlvc: MedPageHTMLViewController = navCtrl.viewControllers[0] as! MedPageHTMLViewController;
            htmlvc.med = (sender as! GlossaryTableViewCell).medication!
        }
    }
}
