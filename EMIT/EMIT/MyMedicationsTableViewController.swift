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
    var itemSaved: Bool {get set};
}

class MyMedicationsTableViewController: AGTableViewController, FilterCellDelegate,
    MyMedicationCellDelegate, InputViewDelegate {

    var myMedications: MyMedications = MyMedications();
    var itemSaved = false;
    
    @IBOutlet var moreButton: UIBarButtonItem!
    
    @IBAction func moreButtonPressed(sender: UIButton){
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
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(discontinued)
        alertController.addAction(send)
        alertController.addAction(cancel)
        
        alertController.popoverPresentationController?.barButtonItem = moreButton
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
    
    func filterMedList(time: String){
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None);
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
        self.tableView.allowsSelection = false;
        self.tableView.estimatedRowHeight = 130;
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let tutorialShown = defaults.objectForKey("tutorialShown") as? Bool;
        
        if (tutorialShown == nil || tutorialShown == false){
            let tutorial = UIStoryboard(name: "ModalViews", bundle: nil).instantiateViewControllerWithIdentifier("Tutorial")
            self.presentViewController(tutorial, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.backgroundColor = UIColor.whiteColor() //EMITTanColor()
        
        
        // Time Icons
        cell.breakfastImage.image = UIImage(named: "sunrise-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.lunchImage.image = UIImage(named: "noon-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.dinnerImage.image = UIImage(named: "sunset-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.bedImage.image = UIImage(named: "night-filled")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        
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
