//
//  MyMedicationsTableViewController.swift
//  EMIT Project
//
//  Created by Andrew on 26/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
//
//enum TimeOfDay {
//    case Breakfast
//    case Lunch
//    case Dinner
//    case Bed
//}
//
//let unselectedColor = UIColor.EMITMediumGreyColor()
//let breakfastColor = UIColor.morningColor()
//let lunchColor = UIColor.noonColor()
//let dinnerColor = UIColor.sunsetColor()
//let bedColor = UIColor.moonColor()
//
//protocol FilterCellDelegate {
//    func filterMedList(time: TimeOfDay?);
//}
//
//protocol MyMedicationCellDelegate {
//    func editMed(cell: MyMedicationTableViewCell)
//}
//
//protocol InputViewDelegate {
//    var itemSaved: Bool {get set};
//}
//

class MyMedicationsViewController: UIViewController, FilterCellDelegate,
    MyMedicationCellDelegate, InputViewDelegate, UIActivityItemSource, UITableViewDataSource, UITableViewDelegate {

    var myMedications: MyMedications = MyMedications();
    var itemSaved = false;
    var filterTime: TimeOfDay?
    
    @IBOutlet var filterView: UIView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var moreButton: UIBarButtonItem!
    
    @IBAction func moreButtonPressed(sender: UIBarButtonItem){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let discontinued = UIAlertAction(title: "Discontinued Medications", style: .Default, handler: { (action) -> Void in
            let discMeds = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("DiscontinuedMeds")
            self.navigationController?.pushViewController(discMeds, animated: true)
            
        })
        let send = UIAlertAction(title: "Send Medications", style: .Default, handler: { (action) -> Void in
            let navCtrl = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("SendMedsNav") as! UINavigationController
            let smvc: SendMedsViewController = navCtrl.viewControllers[0] as! SendMedsViewController;
            smvc.allMeds = self.myMedications
            
            self.presentViewController(navCtrl, animated: true, completion: nil)
        })
        
        let share = UIAlertAction(title: "Share", style: .Default) { (action) in
            
            let objectsToShare = [self]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAirDrop, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypeOpenInIBooks, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTwitter, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll]
            
//            activityVC.setValue("My Medication List", forKey: "subject")
            
            activityVC.popoverPresentationController?.barButtonItem = sender
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(discontinued)
        alertController.addAction(send)
        alertController.addAction(share)
        alertController.addAction(cancel)
        
        alertController.popoverPresentationController?.barButtonItem = moreButton
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return myMedications.toShareString()
    }
    
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        if activityType == UIActivityTypeMail {
            return myMedications.toHTMLTable()
        } else {
            return myMedications.toShareString()
        }
    }
    
    @IBAction func newMyMedication(button: UIButton){
        let navCtrl = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("MyMedNav") as! UINavigationController
            let mmvc: MyMedicationViewController = navCtrl.viewControllers[0] as! MyMedicationViewController;
            mmvc.delegate = self;
            mmvc.newMode = true;

        self.presentViewController(navCtrl, animated: true, completion: nil);
    }
    
    func imageTapped(sender: UITapGestureRecognizer){
        let fivc = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("FullImage") as! FullImageViewController
        fivc.image = (sender.view as! AGImageView).fullImage
        
        self.presentViewController(fivc, animated: true, completion: nil)
    }
    
    func editMed(cell: MyMedicationTableViewCell){
        let navCtrl = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("MyMedNav") as! UINavigationController
        let mmvc: MyMedicationViewController = navCtrl.viewControllers[0] as! MyMedicationViewController;
        mmvc.med = cell.myMedication;
        mmvc.delegate = self;
        mmvc.newMode = false;
        
        self.presentViewController(navCtrl, animated: true, completion: nil)
    }
    
    @IBOutlet var breakfastButton: UIButton!;
    @IBOutlet var lunchButton: UIButton!;
    @IBOutlet var dinnerButton: UIButton!;
    @IBOutlet var bedButton: UIButton!;
    
    var selectedTime: TimeOfDay?
    let unselectedColor = UIColor.EMITMediumGreyColor()
    let breakfastColor = UIColor.morningColor()
    let lunchColor = UIColor.noonColor()
    let dinnerColor = UIColor.sunsetColor()
    let bedColor = UIColor.moonColor()
    
    
    func toggleButton(time: TimeOfDay?) {
        
        breakfastButton.tintColor = unselectedColor;
        lunchButton.tintColor = unselectedColor;
        dinnerButton.tintColor = unselectedColor;
        bedButton.tintColor = unselectedColor;
        
        if time == nil || time == selectedTime {
            filterMedList(nil)
            selectedTime = nil
        } else {
            filterMedList(time!)
            selectedTime = time!
            switch (time!) {
            case .Breakfast:
                breakfastButton.tintColor = breakfastColor
            case .Lunch:
                lunchButton.tintColor = lunchColor
            case .Dinner:
                dinnerButton.tintColor = dinnerColor
            case .Bed:
                bedButton.tintColor = bedColor
            }
        }
    }
    
    @IBAction func toggleBreakfast(){
        toggleButton(TimeOfDay.Breakfast)
    }
    
    @IBAction func toggleLunch(){
        toggleButton(TimeOfDay.Lunch)
    }
    
    @IBAction func toggleDinner(){
        toggleButton(TimeOfDay.Dinner)
    }
    
    @IBAction func toggleBed(){
        toggleButton(TimeOfDay.Bed)
    }
    
    func filterMedList(time: TimeOfDay?){
        filterTime = time
        
        self.tableView.reloadData()
        
//        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic);
    }

    override func viewWillDisappear(animated: Bool) {
        toggleButton(nil)
    }
    
    override func viewWillAppear(animated: Bool){
        myMedications.meds = Data.getAllMyMedications();
        myMedications.sortAlphabetically()
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
        self.filterView.backgroundColor = UIColor.EMITLightGreyColor()
        self.tableView.allowsSelection = false;
        self.tableView.estimatedRowHeight = 130;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.backgroundColor = UIColor.EMITLightGreyColor()
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let tutorialShown = defaults.objectForKey("tutorialShown") as? Bool;
        
        if (tutorialShown == nil || tutorialShown == false){
            let tutorial = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("Tutorial")
            self.presentViewController(tutorial, animated: true, completion: nil)
        }
        
        
        breakfastButton.setImage(UIImage(named: "sunrise-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        lunchButton.setImage(UIImage(named: "noon-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        dinnerButton.setImage(UIImage(named: "sunset-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        bedButton.setImage(UIImage(named: "night-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        
        breakfastButton.tintColor = unselectedColor
        lunchButton.tintColor = unselectedColor
        dinnerButton.tintColor = unselectedColor
        bedButton.tintColor = unselectedColor
        
//        if filterTime != nil {
//            let time = filterTime!
//            switch (time) {
//            case TimeOfDay.Breakfast:
//                cell.breakfastButton.tintColor = breakfastColor
//            case TimeOfDay.Lunch:
//                cell.lunchButton.tintColor = lunchColor
//            case TimeOfDay.Dinner:
//                cell.dinnerButton.tintColor = dinnerColor
//            case TimeOfDay.Bed:
//                cell.bedButton.tintColor = bedColor
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if filterTime == nil {
            return myMedications.getCurrentMeds().count // + 1; // +1 for Filter Cell
//        } else {
//            return myMedications.countCurrentMedsAtTime(filterTime!) // + 1
//        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("MedicationFilterCell", forIndexPath: indexPath) as! MyMedicationFilterTableViewCell;
//            cell.delegate = self;
//            
//            // Time Icons
//            cell.breakfastButton.setImage(UIImage(named: "sunrise-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
//            cell.lunchButton.setImage(UIImage(named: "noon-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
//            cell.dinnerButton.setImage(UIImage(named: "sunset-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
//            cell.bedButton.setImage(UIImage(named: "night-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
//            
//            cell.breakfastButton.tintColor = unselectedColor
//            cell.lunchButton.tintColor = unselectedColor
//            cell.dinnerButton.tintColor = unselectedColor
//            cell.bedButton.tintColor = unselectedColor
//            
//            if filterTime != nil {
//                let time = filterTime!
//                switch (time) {
//                case TimeOfDay.Breakfast:
//                    cell.breakfastButton.tintColor = breakfastColor
//                case TimeOfDay.Lunch:
//                    cell.lunchButton.tintColor = lunchColor
//                case TimeOfDay.Dinner:
//                    cell.dinnerButton.tintColor = dinnerColor
//                case TimeOfDay.Bed:
//                    cell.bedButton.tintColor = bedColor
//                }
//            }
//            
//            return cell
        //
        //        } else {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyMedicationCell", forIndexPath: indexPath) as! MyMedicationTableViewCell;
        cell.delegate = self;
        
        cell.nameBackground.layer.cornerRadius = 5
        
        var med: MyMedication = MyMedication()
        if filterTime == nil {
            med = myMedications.getCurrentMeds()[indexPath.row];
            cell.nameBackground.backgroundColor = UIColor.whiteColor()
//            cell.contentView.backgroundColor = UIColor.whiteColor()
        } else {
//            med = myMedications.currentMedsAtTime(filterTime!)[indexPath.row];
            med = MyMedications.timeFirstSort(myMedications.getCurrentMeds(), time: filterTime!)[indexPath.row]
            let countAtTime = myMedications.countTakenAtTime(filterTime!)
            
            if (indexPath.row < countAtTime) {
                switch (filterTime!) {
                case .Breakfast:
                    cell.nameBackground.backgroundColor = breakfastColor.lighter()
//                    cell.contentView.backgroundColor = breakfastColor.lighter()
                case .Lunch:
                    cell.nameBackground.backgroundColor = lunchColor.lighter()
//                    cell.contentView.backgroundColor = lunchColor.lighter()
                case .Dinner:
                    cell.nameBackground.backgroundColor = dinnerColor.lighter()
//                    cell.contentView.backgroundColor = dinnerColor.lighter()
                case .Bed:
                    cell.nameBackground.backgroundColor = bedColor.lighter()
//                    cell.contentView.backgroundColor = bedColor.lighter()
                }
            } else {
                cell.nameBackground.backgroundColor = UIColor.whiteColor()
//                cell.contentView.backgroundColor = UIColor.whiteColor()
            }
            
        }
        
        cell.myMedication = med;
        cell.medName.text = med.name;
        cell.medInstructions.text = med.instructions;
        cell.backgroundColor = UIColor.whiteColor() //EMITTanColor()
        
        
        // Time Icons
        cell.breakfastImage.image = UIImage(named: "sunrise-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.lunchImage.image = UIImage(named: "noon-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.dinnerImage.image = UIImage(named: "sunset-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.bedImage.image = UIImage(named: "night-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        cell.breakfastImage.tintColor = UIColor.lightLightGrayColor()
        cell.lunchImage.tintColor = UIColor.lightLightGrayColor()
        cell.dinnerImage.tintColor = UIColor.lightLightGrayColor()
        cell.bedImage.tintColor = UIColor.lightLightGrayColor()
        
        if (med.breakfast){
            cell.breakfastImage.tintColor = breakfastColor
        }
        if (med.lunch){
            cell.lunchImage.tintColor = UIColor.noonColor()
        }
        if (med.dinner){
            cell.dinnerImage.tintColor = UIColor.sunsetColor()
        }
        if (med.bed){
            cell.bedImage.tintColor = UIColor.moonColor()
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
        
        //        }
    }
}
