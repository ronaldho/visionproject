//
//  SymptomSplitViewController.swift
//  Vision Project
//
//  Created by Andrew on 11/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate {
    func dateChanged(calendarSelectedDate: NSDate?);
    func setCalendarContainerHeight(height: CGFloat);
}

protocol SymptomTableDelegate {
    func editSymptom(cell: SymptomTableViewCell);
}

class SymptomSplitViewController: UIViewController, CalendarViewDelegate, SymptomTableDelegate, InputViewDelegate {
    

    @IBOutlet var calendar: SymptomCalendarViewController!;
    @IBOutlet var calendarContainer: UIView!;
    @IBOutlet var symptomsTable: SymptomSplitTableViewController!;
    @IBOutlet var symptomsContainer: UIView!;
    @IBOutlet var symptomsContainerTopConstraintLayout: NSLayoutConstraint!;
    @IBOutlet var symptomsContainerTopConstraintCalendar: NSLayoutConstraint!;
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!;
    
    var calendarSelectedDate: NSDate?
    var symptoms: Symptoms = Symptoms();
    var selectedDaySymptoms: Symptoms?;
    
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
        
        if calendarContainer.hidden == true {
            calendarContainer.hidden = false;
            symptomsContainerTopConstraintLayout.priority = 400;
            
            if (calendar.selectedCell != nil){
                selectedDaySymptoms = Symptoms();
                selectedDaySymptoms = getSymptomsWithDate(calendar.selectedCell!.date)
            }
        } else {
            calendarContainer.hidden = true;
            symptomsContainerTopConstraintLayout.priority = 600;

            selectedDaySymptoms = nil;
        }

        reloadSymptoms();
    }
    
    func reloadSymptoms(){
        if selectedDaySymptoms != nil {
            symptomsTable.symptoms = self.selectedDaySymptoms!;
        } else {
            symptomsTable.symptoms = self.symptoms;
        }
        
        symptomsTable.tableView.reloadData();
    }
    
    func getSymptomsWithDate(date: NSDate) -> Symptoms{
        let temp = Symptoms();
        temp.symptoms = Data.getAllSymptoms();
        
        if (temp.symptoms.count > 0){
            for i in (0...(temp.symptoms.count-1)).reverse() {
                if !temp.symptoms[i].date.sameDate(date){
                    temp.symptoms.removeAtIndex(i);
                }
            }
        }

        return temp;
    }
    
    func setCalendarContainerHeight(height: CGFloat){
        calendarHeightConstraint.constant = height;
    }
    
    func editSymptom(cell: SymptomTableViewCell){
        performSegueWithIdentifier("EditSymptom", sender: cell)
    }
    
    
    func dateChanged(calendarSelectedDate: NSDate?){
        
        if (selectedDaySymptoms == nil){
            selectedDaySymptoms = Symptoms();
        }
        
        selectedDaySymptoms! = getSymptomsWithDate(calendarSelectedDate!);
        
        if symptomsTable != nil {
            reloadSymptoms();
        }
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

//            if calendarSelectedDate != nil {
//                sstvc.showSymptomsWithDate(calendarSelectedDate!);
//            } else {
//                sstvc.showAllSymptoms();
//            }
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
            symptomsTable.symptoms = selectedDaySymptoms!;
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
