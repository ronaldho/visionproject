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

class SymptomSplitViewController: UIViewController, CalendarViewDelegate {

    @IBOutlet var calendar: SymptomCalendarViewController!;
    @IBOutlet var symptomsTable: UITableViewController!;
    
    @IBAction func flip(){
        performSegueWithIdentifier("SymptomTableView", sender: self)
    }
    
    func dateChanged(date: NSDate){
        print("dateChanged " + String(date));
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SymptomCalendarEmbed"){
            let scvc = segue.destinationViewController as! SymptomCalendarViewController;
            scvc.delegate = self;
            calendar = scvc;
            
        } else if (segue.identifier == "SymptomTableEmbed"){
//            let navCtrl = segue.destinationViewController as! UINavigationController;
//            let svc: SymptomViewController = navCtrl.viewControllers[0] as! SymptomViewController;
//            svc.symptom = (sender as! SymptomTableViewCell).symptom!;
//            svc.delegate = self;
//            svc.newMode = false;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
