//
//  MedAlarmsViewController.swift
//  EMIT
//
//  Created by Andrew on 25/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MedAlarmsViewController: AGInputViewController {

    

    @IBOutlet weak var breakfastSwitch: UISwitch!
    @IBOutlet weak var lunchSwitch: UISwitch!
    @IBOutlet weak var dinnerSwitch: UISwitch!
    @IBOutlet weak var bedSwitch: UISwitch!
    @IBOutlet weak var breakfastTimeField: UITextField!
    @IBOutlet weak var lunchTimeField: UITextField!
    @IBOutlet weak var dinnerTimeField: UITextField!
    @IBOutlet weak var bedTimeField: UITextField!

    @IBOutlet weak var instructionsStack: UIStackView!
    @IBOutlet weak var alarmsStack: UIStackView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var breakfastTime: NSDate?
    var lunchTime: NSDate?
    var dinnerTime: NSDate?
    var bedTime: NSDate?


    @IBAction func settingsButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
//        self.viewWillAppear(false)
    }
    
    
    func registerForAlerts() {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    func findAlert(type: String) -> UILocalNotification? {
        var localNotification: UILocalNotification?
        
        let localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications
        
        if localNotifications != nil {
            
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
                let info = notification.userInfo! as! [String: AnyObject]
                if let notifType = info["type"] as? String {
                    if notifType == type {
                        localNotification = notification
                    }
                }
            }
        }
        
        return localNotification
    }
    
    func listAlerts(){
        let localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications
        
        if localNotifications != nil {
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
                print("fireDate: \(notification.fireDate!.getTimeFormat()), alertBody: \(notification.alertBody)")
            }
        }
    }
    
    func startAlert(time: NSDate, type: String, timeOfDay: TimeOfDay) {
        let existingNotification = findAlert(type)
        if existingNotification != nil {
            stopAlert(type)
        }
        
        let notification = UILocalNotification()
        notification.fireDate = time
        notification.repeatInterval = NSCalendarUnit.Day
        notification.alertBody = "Time to take your \(type.lowercaseString) medications"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["type": type, "timeOfDay": timeOfDay.rawValue];
        notification.applicationIconBadgeNumber += 1
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
        datePickerView.minuteInterval = 1;
        
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
            doneButton.addTarget(self, action: #selector(MedAlarmsViewController.doneButtonBreakfast(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            datePickerView.addTarget(self, action: #selector(MedAlarmsViewController.handleBreakfastTimePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
            datePickerView.setDate((breakfastTime == nil) ? NSDate.getTimeOfDay(8) : breakfastTime!, animated: true)
            
            handleBreakfastTimePicker(datePickerView)
            
            
        } else if (sender == lunchTimeField){
            doneButton.addTarget(self, action: #selector(MedAlarmsViewController.doneButtonLunch(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            datePickerView.addTarget(self, action: #selector(MedAlarmsViewController.handleLunchTimePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
            datePickerView.setDate((lunchTime == nil) ? NSDate.getTimeOfDay(12) : lunchTime!, animated: true)
            
            handleLunchTimePicker(datePickerView)
            
        } else if (sender == dinnerTimeField){
            doneButton.addTarget(self, action: #selector(MedAlarmsViewController.doneButtonDinner(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            datePickerView.addTarget(self, action: #selector(MedAlarmsViewController.handleDinnerTimePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
            datePickerView.setDate((dinnerTime == nil) ? NSDate.getTimeOfDay(18) : dinnerTime!, animated: true)
            
            handleDinnerTimePicker(datePickerView)
            
        } else if (sender == bedTimeField){
            doneButton.addTarget(self, action: #selector(MedAlarmsViewController.doneButtonBed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            datePickerView.addTarget(self, action: #selector(MedAlarmsViewController.handleBedTimePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
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
        self.navigationItem.title = "Medication Alarms"
        
        
        super.viewDidLoad()
        
        // Hide everything
        instructionsStack.hidden = true
        alarmsStack.hidden = true
        
        // Ask permission for alerts if first time
        registerForAlerts()
        
        // Check current notification settings. If not enabled, show instructions to enable. 
        // If enabled, load Alarms settings.
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if !settings!.types.contains(.Alert) {
            instructionsStack.hidden = false
            self.view.backgroundColor = UIColor.whiteColor();
            
        } else {
            alarmsStack.hidden = false
            self.view.backgroundColor = UIColor.EMITLightGreyColor()
            
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
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        var alertEnabled: Bool = false;
        let defaults = NSUserDefaults.standardUserDefaults()

        if (breakfastTime != nil && breakfastSwitch.on) {
            defaults.setObject(breakfastTime!, forKey: "breakfastAlarmTime")
            startAlert(breakfastTime!, type: "Breakfast", timeOfDay: .Breakfast)
            alertEnabled = true
        } else {
            defaults.removeObjectForKey("breakfastAlarmTime")
            stopAlert("Breakfast")
        }
        
        if (lunchTime != nil && lunchSwitch.on) {
            defaults.setObject(lunchTime!, forKey: "lunchAlarmTime")
            startAlert(lunchTime!, type: "Lunch", timeOfDay: .Lunch)
            alertEnabled = true
        } else {
            defaults.removeObjectForKey("lunchAlarmTime")
            stopAlert("Lunch")
        }
        
        if (dinnerTime != nil && dinnerSwitch.on) {
            defaults.setObject(dinnerTime!, forKey: "dinnerAlarmTime")
            startAlert(dinnerTime!, type: "Dinner", timeOfDay: .Dinner)
            alertEnabled = true
        } else {
            defaults.removeObjectForKey("dinnerAlarmTime")
            stopAlert("Dinner")
        }
        
        if (bedTime != nil && bedSwitch.on) {
            defaults.setObject(bedTime!, forKey: "bedAlarmTime")
            startAlert(bedTime!, type: "Bed", timeOfDay: .Bed)
            alertEnabled = true
        } else {
            defaults.removeObjectForKey("bedAlarmTime")
            stopAlert("Bed")
        }
        
        
        if (alertEnabled) {
            let alertStyleWarningShown = defaults.objectForKey("alertStyleWarningShown") as? Bool;
            
            if (alertStyleWarningShown == nil || alertStyleWarningShown == false) {
                let alertStyleWarning = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("AlertStyleWarning")
                self.presentViewController(alertStyleWarning, animated: true, completion: nil)
            }
        } else {
            print("No alerts")
        }
        
        listAlerts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
