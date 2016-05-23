//
//  GlossaryTableViewController.swift
//  Vision Project
//
//  Created by Andrew on 9/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Foundation


class GlossaryTableViewController: UITableViewController {

    var medications: Medications = Medications();
    
    override func viewWillAppear(animated: Bool){
        
        medications.medications = Data.getAllMedications();
        self.tableView.reloadData()
        
//        print("glossary viewWillAppear");
//        // Clear current data
//        medications = Medications();
//        self.tableView.reloadData();
//        
//        // Block UI and tell user to wait
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
//        
//        alert.view.tintColor = UIColor.blackColor()
//        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        loadingIndicator.startAnimating();
//        
//        alert.view.addSubview(loadingIndicator)
//        presentViewController(alert, animated: true, completion: nil)
//        
//        // Prepare request
//        let url = NSURL(string: "http://vision-rest.herokuapp.com/drugs")
//        let request = NSURLRequest(URL: url!)
//        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//        let session = NSURLSession(configuration: config)
//        
//        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
//            // Callback when response received
//            print("task callback");
//            
//            var json: [[String: AnyObject]] = [[:]];
//            do {
//                json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [[String:AnyObject]];
//            } catch {
//                print(error)
//            }
//            
//            print(json);
//            print("json count: \(json.count)");
//            
//            for medication in json{
//                //                print ("medication: \(medication)");
//                if let name = medication["name"] as? String{
//                    self.medications.medications.append(Medication(withName: name, andImage: nil, andCroppedImage: nil,
//                        andInfo: "", andId: ""));
//                }
//            }
//            
//            self.tableView.performSelectorOnMainThread(#selector(self.tableView.reloadData), withObject: nil, waitUntilDone: true)
//            
//            // Unblock UI
//            alert.dismissViewControllerAnimated(false, completion: nil)
//            
//        });
//        
//        // Send request
//        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor.visionDarkGreenColor();
        
//        self.tableView.allowsSelection = false;
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 25;
        self.tableView.backgroundColor = UIColor.visionTanColor();
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
        if (medication.image == nil) {
            print("image nil for \(medication.name)")
        }
        cell.medImageView.image = medication.image;
        cell.backgroundColor = UIColor.visionTanColor();

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("MedInfoFromGlossary", sender: tableView.cellForRowAtIndexPath(indexPath))
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
