//
//  MyMedicationsTableViewController.swift
//  EMIT Project
//
//  Created by Andrew on 26/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit


protocol SymptomCellDelegate {
    func editSymptom(cell: SymptomTableViewCell)
}

class SymptomTableViewController: AGTableViewController,
SymptomCellDelegate, InputViewDelegate {
    
    var symptoms: Symptoms = Symptoms();
    var itemSaved = false;
    
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
            print("EditSymptom segue in SymptomTableViewController.prepareForSeque()");
            
        } else if (segue.identifier == "SendSymptomPopover"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let sendvc: SendSymptomsViewController = navCtrl.viewControllers[0] as! SendSymptomsViewController;
            sendvc.allSymptoms = self.symptoms;
        }
    }
    
    @IBAction func sendButtonPressed(){
        let ms: MailSender? = MailSender(parentVC: self);
        if ((ms?.anyMailAvailable()) != nil){
            let navCtrl = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("SendSymptomNav") as! UINavigationController
            let sendvc: SendSymptomsViewController = navCtrl.viewControllers[0] as! SendSymptomsViewController;
            sendvc.allSymptoms = self.symptoms;
            
            self.presentViewController(navCtrl, animated: true, completion: nil)
            
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
        let navCtrl = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("SymptomNav") as! UINavigationController
        let svc: SymptomViewController = navCtrl.viewControllers[0] as! SymptomViewController;
        svc.delegate = self;
        svc.newMode = true;
        
        self.presentViewController(navCtrl, animated: true, completion: nil);
    }
    
    func editSymptom(cell: SymptomTableViewCell) {
        let navCtrl = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("SymptomNav") as! UINavigationController
        let svc: SymptomViewController = navCtrl.viewControllers[0] as! SymptomViewController;
        svc.symptom = cell.symptom!
        svc.delegate = self;
        svc.newMode = false;
        
        self.presentViewController(navCtrl, animated: true, completion: nil);
    }
    
    func filterMedList(time: String){
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None);
    }
    
    override func viewWillAppear(animated: Bool){
//        symptoms.symptoms = Data.getAllSymptoms();
//        symptoms.sort();
//        self.tableView.reloadData();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 130;
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
        
        cell.backgroundColor = UIColor.whiteColor() //EMITTanColor();
        cell.symptom = symptom;
        cell.dateLabel.text = symptom.date.dayMonthFormat();
        cell.symptomTextLabel.text = symptom.text;
        
        cell.symptomTagStack.subviews.forEach({ $0.removeFromSuperview() })
        
        for symptomTag in symptom.symptomTags {
            let tagView = UIView()
            
            tagView.backgroundColor = symptomTag.color;
            tagView.heightAnchor.constraintEqualToConstant(10).active = true;
            tagView.widthAnchor.constraintEqualToConstant(10).active = true;
            tagView.layer.cornerRadius = 5
            
            cell.symptomTagStack.addArrangedSubview(tagView)
            
        }
        
        return cell
        
        
    }
    
}
