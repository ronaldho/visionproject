//
//  SettingsViewController.swift
//  EMIT
//
//  Created by Andrew on 25/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SettingsViewController: AGInputViewController {

    
    @IBOutlet weak var breakfastSwitch: UISwitch!
    @IBOutlet weak var lunchSwitch: UISwitch!
    @IBOutlet weak var dinnerSwitch: UISwitch!
    @IBOutlet weak var bedSwitch: UISwitch!
    @IBOutlet weak var breakfastTimeField: UITextField!
    @IBOutlet weak var lunchTimeField: UITextField!
    @IBOutlet weak var dinnerTimeField: UITextField!
    @IBOutlet weak var bedTimeField: UITextField!
    
    var breakfastTime: NSDate?
    var lunchTime: NSDate?
    var dinnerTime: NSDate?
    var bedTime: NSDate?
    
    func registerForAlerts() {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    func findAlert(type: String) -> UILocalNotification? {
        var localNotification: UILocalNotification?
        
        let localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications
        
        if localNotifications != nil {
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
                let info = notification.userInfo! as! [String: String]
                if info["type"] == type {
                    localNotification = notification
                }
            }
        }
        
        return localNotification
    }
    
    func listAlerts(){
        let localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications
        
        if localNotifications != nil {
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
                print("fireDate: \(notification.fireDate), alertBody: \(notification.alertBody)")
            }
        }
    }
    
    func startAlert(time: NSDate, type: String) {
        let existingNotification = findAlert(type)
        if existingNotification != nil {
            stopAlert(type)
        }
        
        let notification = UILocalNotification()
        notification.fireDate = time
        notification.repeatInterval = NSCalendarUnit.Day
        notification.alertBody = "\(type) Alert for Medications"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["type": type];
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func stopAlert(type: String){
        let notification = findAlert(type)
        if notification != nil {
            UIApplication.sharedApplication().cancelLocalNotification(notification!)
        }
    }
    
    @IBAction override func dateTextInputPressed(sender: UITextField) {
        
        //Create the view
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.minuteInterval = 5;
        
        datePickerView.center = CGPointMake(inputView.frame.size.width  / 2,
                                            inputView.frame.size.height - datePickerView.frame.size.height / 2);
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        
        sender.inputView = inputView
        if (sender == breakfastTimeField){
            doneButton.addTarget(self, action: #selector(SettingsViewController.doneButtonBreakfast(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            datePickerView.addTarget(self, action: #selector(SettingsViewController.handleBreakfastTimePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
            datePickerView.setDate((breakfastTime == nil) ? NSDate.getTimeOfDay(8) : breakfastTime!, animated: true)
            
            handleBreakfastTimePicker(datePickerView)
            
            
        } else if (sender == lunchTimeField){
            doneButton.addTarget(self, action: #selector(SettingsViewController.doneButtonLunch(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            datePickerView.addTarget(self, action: #selector(SettingsViewController.handleLunchTimePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
            datePickerView.setDate((lunchTime == nil) ? NSDate.getTimeOfDay(12) : lunchTime!, animated: true)
            
            handleLunchTimePicker(datePickerView)
            
        } else if (sender == dinnerTimeField){
            doneButton.addTarget(self, action: #selector(SettingsViewController.doneButtonDinner(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            datePickerView.addTarget(self, action: #selector(SettingsViewController.handleDinnerTimePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
            datePickerView.setDate((dinnerTime == nil) ? NSDate.getTimeOfDay(18) : dinnerTime!, animated: true)
            
            handleDinnerTimePicker(datePickerView)
            
        } else if (sender == bedTimeField){
            doneButton.addTarget(self, action: #selector(SettingsViewController.doneButtonBed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            datePickerView.addTarget(self, action: #selector(SettingsViewController.handleBedTimePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
            datePickerView.setDate((bedTime == nil) ? NSDate.getTimeOfDay(22) : bedTime!, animated: true)
            
            handleBedTimePicker(datePickerView)
        }
    }
    
    func handleBreakfastTimePicker(sender: UIDatePicker) {
        breakfastTimeField!.text = sender.date.getTimeFormat()
        breakfastTime = sender.date;
    }
    
    func handleLunchTimePicker(sender: UIDatePicker) {
        lunchTimeField!.text = sender.date.getTimeFormat()
        lunchTime = sender.date;
    }
    
    func handleDinnerTimePicker(sender: UIDatePicker) {
        dinnerTimeField!.text = sender.date.getTimeFormat()
        dinnerTime = sender.date;
    }
    
    func handleBedTimePicker(sender: UIDatePicker) {
        bedTimeField!.text = sender.date.getTimeFormat()
        bedTime = sender.date;
    }
    
    
    func doneButtonBreakfast(sender:UIButton)
    {
        breakfastTimeField!.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func doneButtonLunch(sender:UIButton)
    {
        lunchTimeField!.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func doneButtonDinner(sender:UIButton)
    {
        dinnerTimeField!.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func doneButtonBed(sender:UIButton)
    {
        bedTimeField!.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        breakfastTime = defaults.objectForKey("breakfastAlarmTime") as? NSDate;
        lunchTime = defaults.objectForKey("lunchAlarmTime") as? NSDate;
        dinnerTime = defaults.objectForKey("dinnerAlarmTime") as? NSDate;
        bedTime = defaults.objectForKey("bedAlarmTime") as? NSDate;
        
        if (breakfastTime != nil) {
            breakfastSwitch.setOn(true, animated: false)
            breakfastTimeField.text = breakfastTime!.getTimeFormat()
        } else {
            breakfastSwitch.setOn(false, animated: false)
            breakfastTimeField.text = ""
        }
        if (lunchTime != nil) {
            lunchSwitch.setOn(true, animated: false)
            lunchTimeField.text = lunchTime!.getTimeFormat()
        } else {
            lunchSwitch.setOn(false, animated: false)
            lunchTimeField.text = ""
        }
        if (dinnerTime != nil) {
            dinnerSwitch.setOn(true, animated: false)
            dinnerTimeField.text = dinnerTime!.getTimeFormat()
        } else {
            dinnerSwitch.setOn(false, animated: false)
            dinnerTimeField.text = ""
        }
        if (bedTime != nil) {
            bedSwitch.setOn(true, animated: false)
            bedTimeField.text = bedTime!.getTimeFormat()
        } else {
            bedSwitch.setOn(false, animated: false)
            bedTimeField.text = ""
        }
        
        print("Settings viewWillAppear: breakfastTime:\(breakfastTime) lunchTime:\(lunchTime) dinnerTime:\(dinnerTime) bedTime:\(bedTime)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        var alertEnabled: Bool = false;
        let defaults = NSUserDefaults.standardUserDefaults()

        if (breakfastTime != nil && breakfastSwitch.on) {
            defaults.setObject(breakfastTime!, forKey: "breakfastAlarmTime")
            startAlert(breakfastTime!, type: "Breakfast")
            alertEnabled = true
        } else {
            defaults.removeObjectForKey("breakfastAlarmTime")
            stopAlert("Breakfast")
        }
        
        if (lunchTime != nil && lunchSwitch.on) {
            defaults.setObject(lunchTime!, forKey: "lunchAlarmTime")
            startAlert(lunchTime!, type: "Lunch")
            alertEnabled = true
        } else {
            defaults.removeObjectForKey("lunchAlarmTime")
            stopAlert("Lunch")
        }
        
        if (dinnerTime != nil && dinnerSwitch.on) {
            defaults.setObject(dinnerTime!, forKey: "dinnerAlarmTime")
            startAlert(dinnerTime!, type: "Dinner")
            alertEnabled = true
        } else {
            defaults.removeObjectForKey("dinnerAlarmTime")
            stopAlert("Dinner")
        }
        
        if (bedTime != nil && bedSwitch.on) {
            defaults.setObject(bedTime!, forKey: "bedAlarmTime")
            startAlert(bedTime!, type: "Bed")
            alertEnabled = true
        } else {
            defaults.removeObjectForKey("bedAlarmTime")
            stopAlert("Bed")
        }
        
        
        if (alertEnabled) {
            registerForAlerts()
//            listAlerts()
            
            let alertStyleWarningShown = defaults.objectForKey("alertStyleWarningShown") as? Bool;
            
            if (alertStyleWarningShown == nil || alertStyleWarningShown == false) {
                performSegueWithIdentifier("AlertStyleWarning", sender: self)
            }
        } else {
            print("No alerts")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
