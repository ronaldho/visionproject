//
//  MyMedicationsTableViewController.swift
//  EMIT Project
//
//  Created by Andrew on 26/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

protocol FilterCellDelegate {
    func filterMedList(time: String);
}

protocol MyMedicationCellDelegate {
    func editMed(cell: MyMedicationTableViewCell)
}

protocol InputViewDelegate {
//    var itemToScrollToId: String? {get set};
//    func autoscroll();
    var itemSaved: Bool {get set};
}

class MyMedicationsTableViewController: AGTableViewController, FilterCellDelegate,
    MyMedicationCellDelegate, InputViewDelegate {

    var myMedications: MyMedications = MyMedications();
    var itemSaved = false;
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "NewMyMedication"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let mmvc: MyMedicationViewController = navCtrl.viewControllers[0] as! MyMedicationViewController;
            mmvc.delegate = self;
            mmvc.newMode = true;
            
        } else if (segue.identifier == "EditMyMedication"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let mmvc: MyMedicationViewController = navCtrl.viewControllers[0] as! MyMedicationViewController;
            mmvc.med = (sender as! MyMedicationTableViewCell).myMedication;
            mmvc.delegate = self;
            mmvc.newMode = false;
            
        } else if (segue.identifier == "FullImageFromMyMeds") {
            let fivc = segue.destinationViewController as! FullImageViewController;
            fivc.image = ((sender as! UITapGestureRecognizer).view as! AGImageView).fullImage
        }
    }
    
    @IBAction func newMyMedication(button: UIButton){
        performSegueWithIdentifier("NewMyMedication", sender: button)
    }
    
    func imageTapped(sender: UITapGestureRecognizer){
        performSegueWithIdentifier("FullImageFromMyMeds", sender: sender)
    }
    
    func editMed(cell: MyMedicationTableViewCell){
        performSegueWithIdentifier("EditMyMedication", sender: cell);
    }
    
    func filterMedList(time: String){
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None);
    }
    
    override func viewWillAppear(animated: Bool){
        myMedications.meds = Data.getAllMyMedications();
        self.tableView.reloadData();
        
//        if (itemSaved){
//            itemSaved = false;
//            OverlayView.shared.createOverlay(self.view,text: "Medication Saved");
//            
//            _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(MyMedicationsTableViewController.hideOverlay), userInfo: nil, repeats: false)
//        }
        
        
    }
    
//    func hideOverlay(){
//        OverlayView.shared.hideOverlayView();
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false;
        self.tableView.estimatedRowHeight = 130;
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        registerLocal(self)
        scheduleLocal(self)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func registerLocal(sender: AnyObject) {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    func scheduleLocal(sender: AnyObject) {
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 15)
        notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
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
        return myMedications.getCurrentMeds().count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyMedicationCell", forIndexPath: indexPath) as! MyMedicationTableViewCell;
        cell.delegate = self;
        let med = myMedications.getCurrentMeds()[indexPath.row];
        cell.myMedication = med;
        cell.medName.text = med.name;
        cell.medInstructions.text = med.instructions;
        cell.backgroundColor = UIColor.EMITTanColor()
        
//        // Time Icons
//        cell.breakfastImage.image = UIImage(named: "coffee")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//        cell.lunchImage.image = UIImage(named: "sun")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//        cell.dinnerImage.image = UIImage(named: "restaurant")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//        cell.bedImage.image = UIImage(named: "moon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//
//
//        if (med.breakfast){
//            cell.breakfastImage.tintColor = UIColor.EMITLightGreenColor()
//        } else {
//            cell.breakfastImage.tintColor = UIColor.lightLightGrayColor()
//        }
//        if (med.lunch){
//            cell.lunchImage.tintColor = UIColor.EMITDarkYellowColor()
//        } else {
//            cell.lunchImage.tintColor = UIColor.lightLightGrayColor()
//        }
//        if (med.dinner){
//            cell.dinnerImage.tintColor = UIColor.EMITRedColor()
//        } else {
//            cell.dinnerImage.tintColor = UIColor.lightLightGrayColor()
//        }
//        if (med.bed){
//            cell.bedImage.tintColor = UIColor.EMITBlueColor()
//        } else {
//            cell.bedImage.tintColor = UIColor.lightLightGrayColor()
//        }
//        
        
        // Time Icons
        cell.breakfastImage.image = UIImage(named: "morning")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.lunchImage.image = UIImage(named: "noon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.dinnerImage.image = UIImage(named: "sunset")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.bedImage.image = UIImage(named: "moonnew")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        
        if (med.breakfast){
            cell.breakfastImage.tintColor = UIColor.morningColor()
        } else {
            cell.breakfastImage.tintColor = UIColor.lightLightGrayColor()
        }
        if (med.lunch){
            cell.lunchImage.tintColor = UIColor.noonColor()
        } else {
            cell.lunchImage.tintColor = UIColor.lightLightGrayColor()
        }
        if (med.dinner){
            cell.dinnerImage.tintColor = UIColor.sunsetColor()
        } else {
            cell.dinnerImage.tintColor = UIColor.lightLightGrayColor()
        }
        if (med.bed){
            cell.bedImage.tintColor = UIColor.moonColor()
        } else {
            cell.bedImage.tintColor = UIColor.lightLightGrayColor()
        }
        
        
        
        if (med.image != nil){
            cell.medImage.image = med.croppedImage;
            cell.medImage.fullImage = med.image;
            cell.medImage.userInteractionEnabled = true;
        } else {
            cell.medImage.image = UIImage(named: "pill-thumb");
            cell.medImage.userInteractionEnabled = false;
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyMedicationsTableViewController.imageTapped(_:)))
        cell.medImage.addGestureRecognizer(tapRecognizer);
        
        return cell

    }
}
