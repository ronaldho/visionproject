//
//  MyMedicationsTableViewController.swift
//  Vision Project
//
//  Created by Andrew on 26/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit


protocol SymptomCellDelegate {
    func editSymptom(cell: SymptomTableViewCell)
}

class SymptomTableViewController: UITableViewController,
SymptomCellDelegate, InputViewDelegate {
    
    var symptoms: Symptoms = Symptoms();
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "NewSymptom"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let svc: SymptomViewController = navCtrl.viewControllers[0] as! SymptomViewController;
            svc.delegate = self;
            svc.newMode = true;
            
        } else if (segue.identifier == "EditSymptom"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let svc: SymptomViewController = navCtrl.viewControllers[0] as! SymptomViewController;
            svc.symptom = (sender as! SymptomTableViewCell).symptom!;
            svc.delegate = self;
            svc.newMode = false;
        } else if (segue.identifier == "SendSymptomPopover"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let sendvc: SendViewController = navCtrl.viewControllers[0] as! SendViewController;
            sendvc.allSymptoms = self.symptoms;
        }
    }
    
    @IBAction func sendButtonPressed(){
        let ms: MailSender? = MailSender(parentVC: self);
        if ((ms?.anyMailAvailable()) != nil){
            performSegueWithIdentifier("SendSymptomPopover", sender: self);
        } else {
            let alertController = UIAlertController(title: nil, message: "No mail account found, please set up an account in iOS Mail app or Gmail", preferredStyle: .Alert)
            
            let actionOk = UIAlertAction(title: "OK",
                                         style: .Default,
                                         handler: nil)
            
            alertController.addAction(actionOk)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func newSymptom(button: UIButton){
        performSegueWithIdentifier("NewSymptom", sender: button)
    }
    
    func editSymptom(cell: SymptomTableViewCell) {
        performSegueWithIdentifier("EditSymptom", sender: cell);
    }
    
    func filterMedList(time: String){
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None);
    }
    
    override func viewWillAppear(animated: Bool){
        symptoms.symptoms = Data.getAllSymptoms();
        symptoms.sort();
        self.tableView.reloadData();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor.visionDarkGreenColor();
        self.tableView.allowsSelection = false;
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 130;
        self.tableView.backgroundColor = UIColor.visionTanColor();
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
        return symptoms.symptoms.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SymptomCell", forIndexPath: indexPath) as! SymptomTableViewCell;
        cell.delegate = self;
        let symptom = symptoms.symptoms[indexPath.row];
        cell.symptom = symptom;
        cell.dateLabel.text = symptom.getDateString();
        cell.symptomTextLabel.text = symptom.text;
        
        return cell
        
        
    }
    
}
