//
//  MyMedicationViewController.swift
//  Vision Project
//
//  Created by Andrew on 30/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MyMedicationViewController: AGInputViewController {

    @IBOutlet var medImage: AGImageView!;
    @IBOutlet var medName: UITextField!;
    @IBOutlet var breakfastImageView: UIImageView!;
    @IBOutlet var lunchImageView: UIImageView!;
    @IBOutlet var dinnerImageView: UIImageView!;
    @IBOutlet var bedImageView: UIImageView!;
    @IBOutlet var medInfo: UITextField!;
    @IBOutlet var medNotes: UITextField!;
    
    var delegate: InputViewDelegate?;
    var savedApptId: String = "";
    var med: MyMedication = MyMedication();
    
    
    @IBAction func deleteMyMedication(){
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let delete = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
            Data.deleteMyMedication(self.med);
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imageTapped(sender: UITapGestureRecognizer){
        performSegueWithIdentifier("FullImageFromMyMedication", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FullImageFromMyMedication" {
            let imageCtrl: FullImageViewController = segue.destinationViewController as! FullImageViewController;
            
            imageCtrl.image = photo!.fullImage;
            imageCtrl.shouldAutorotate();
        }
    }
    
    override func viewDidLoad() {
        if (newMode){
            self.title = "New MyMedication"
            self.deleteButton!.hidden = true;
        } else {
            self.title = "Edit MyMedication"
        }
        
        loadFields();
        
        super.viewDidLoad()
    }
    
    @IBAction func toggleBreakfast(){
        if (med.breakfast){
            med.breakfast = false;
            //breakfastImageView.image =
        } else {
            med.breakfast = true;
            //breakfastImageView.image =
        }
    }
    
    @IBAction func toggleLunch(){
        if (med.lunch){
            med.lunch = false;
            //lunchImageView.image =
        } else {
            med.lunch = true;
            //lunchImageView.image =
        }
    }
    
    @IBAction func toggleDinner(){
        if (med.dinner){
            med.dinner = false;
            //dinnerImageView.image =
        } else {
            med.dinner = true;
            //dinnerImageView.image =
        }
    }
    
    @IBAction func toggleBed(){
        if (med.bed){
            med.bed = false;
            //bedImageView.image =
        } else {
            med.bed = true;
            //bedImageView.image =
        }
    }
    
    override func loadFields(){
        if (med.id != "0"){
            medName.text = med.name;
            medInfo.text = med.info;
            medNotes.text = med.notes;
            
            if (med.breakfast){
                //breakfastImageView.image =
            }
            if (med.lunch){
                //lunchImageView.image =
            }
            if (med.dinner){
                //dinnerImageView.image =
            }
            if (med.bed){
                //bedImageView.image =
            }
            
            if (med.image != nil){
                medImage!.fullImage = med.image;
                medImage!.image = med.croppedImage;
                photoContainer!.hidden = false;
                addPhotoButton!.hidden = true;
            } else {
                photoContainer!.hidden = true;
                addPhotoButton!.hidden = false;
            }
        } else {
            // No MyMedication to Load, probably New view
        }
    }
    
    @IBAction func save(sender: UIButton){
        
        if (date != StaticDates.sharedInstance.defaultDate){
//            let notes: String = (notesField!.textColor == UIColor.greyPlaceholderColor()) ? "" : notesField!.text;
//            let myMedicationId: String =
//            Data.saveMyMedication(MyMedication(withType: myMedicationType.text!, andDate: date, andLocation: myMedicationLocation.text!, andCareProvider: myMedicationCareProvider.text!, andNotes: notes, andPhoto: photo!.fullImage, andCroppedPhoto: photo!.image, andId: med.id));
            
//            delegate?.itemToScrollToId = myMedicationId
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            dateField!.shake(10, delta: 10, speed: 0.1);
        }
    }
    
    override func configureDatePicker(inout picker: UIDatePicker){
        picker.datePickerMode = UIDatePickerMode.DateAndTime
        picker.minuteInterval = 5;
        
        let calendar = NSCalendar.currentCalendar();
        let components = calendar.components([.Year,.Month,.Day], fromDate: NSDate());
        components.hour = 12;
        let newDate: NSDate = calendar.dateFromComponents(components)!;
        
        picker.setDate((date == StaticDates.sharedInstance.defaultDate) ? newDate : date, animated: true)
    }
    
    override func getDateFormat() -> String{
        return "MMMM d, h:mm a"
    }


}
