//
//  SymptomSplitViewController.swift
//  Vision Project
//
//  Created by Andrew on 11/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate {
    func dateChanged(date: NSDate);
}

protocol SymptomTableDelegate {
    func editSymptom(cell: SymptomTableViewCell);
}

class SymptomSplitViewController: UIViewController, CalendarViewDelegate, SymptomTableDelegate, InputViewDelegate {

    var symptoms: Symptoms = Symptoms();
    
    func editSymptom(cell: SymptomTableViewCell){
        performSegueWithIdentifier("EditSymptom", sender: cell)
    }
    
    @IBOutlet var calendar: SymptomCalendarViewController!;
    @IBOutlet var calendarContainer: UIView!;
    @IBOutlet var symptomsTable: SymptomSplitTableViewController!;
    @IBOutlet var symptomsContainer: UIView!;
    @IBOutlet var symptomsContainerTopConstraintLayout: NSLayoutConstraint!;
    @IBOutlet var symptomsContainerTopConstraintCalendar: NSLayoutConstraint!;
    
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
    
    @IBAction func flip(){

//        if calendarContainer.frame.size.height == 0 {
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                self.calendarContainer.frame.size.height = 340
//            })
//        } else {
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                self.calendarContainer.frame.size.height = 0
//            })
//        }
        
        if calendarContainer.hidden == true {
            calendarContainer.hidden = false;
            symptomsContainerTopConstraintLayout.priority = 400;
//            NSLayoutConstraint.activateConstraints([symptomsContainerTopConstraintLayout]);
//            NSLayoutConstraint.deactivateConstraints([symptomsContainerTopConstraintCalendar]);
        } else {
            calendarContainer.hidden = true;
            symptomsContainerTopConstraintLayout.priority = 600;
        }
    }
    
    func dateChanged(date: NSDate){
        print("dateChanged " + String(date));
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SymptomCalendarEmbed"){
            let scvc = segue.destinationViewController as! SymptomCalendarViewController;
            scvc.delegate = self;
            calendar = scvc;
            scvc.symptoms = self.symptoms;
            
            
        } else if (segue.identifier == "SymptomTableEmbed"){
            let sstvc = segue.destinationViewController as! SymptomSplitTableViewController;
            sstvc.delegate = self;
            symptomsTable = sstvc;
            sstvc.symptoms = self.symptoms;
            sstvc.tableView.reloadData();
        }
        
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
            print("EditSymptom segue in SymptomSplitViewController.prepareForSeque()");
        } else if (segue.identifier == "SendSymptomPopover"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let sendvc: SendViewController = navCtrl.viewControllers[0] as! SendViewController;
            sendvc.allSymptoms = self.symptomsTable.symptoms;
        }
    }
    
    override func viewWillAppear(animated: Bool){
        symptoms.symptoms = Data.getAllSymptoms();
        symptoms.sort();
        if (calendar != nil){
            calendar.symptoms = self.symptoms;
            calendar.calendar.reloadData();
        }
        if (symptomsTable != nil){
            symptomsTable.symptoms = self.symptoms;
            symptomsTable.tableView.reloadData();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor.visionDarkGreenColor();

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
