//
//  MyMedicationViewController.swift
//  Vision Project
//
//  Created by Andrew on 30/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MyMedicationViewController: AGInputViewController {

//    @IBOutlet var medImage: AGImageView!;
    @IBOutlet var medName: UITextField!;
    @IBOutlet var breakfastButton: UIButton!;
    @IBOutlet var lunchButton: UIButton!;
    @IBOutlet var dinnerButton: UIButton!;
    @IBOutlet var bedButton: UIButton!;
    @IBOutlet var medInstructions: UITextView!;
    @IBOutlet var discontinueButton: UIButton!;
    @IBOutlet var addFromGlossaryButton: UIButton!;
    @IBOutlet var medInfoButton: UIButton!;
    
    @IBOutlet var medHistoryStack: UIStackView!;
    @IBOutlet var medHistoryTable: UITableView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var delegate: InputViewDelegate?;
    var savedApptId: String = "";
    var med: MyMedication = MyMedication();
    var medList: Medications = Medications();
    var medToAdd: Medication?
    var medAdded: Bool = false;
    var medHistories: [MyMedicationHistory]?;
    
    var breakfastButtonSelected = false;
    var lunchButtonSelected = false;
    var dinnerButtonSelected = false;
    var bedButtonSelected = false;
    
    @IBAction func addMedFromGlossaryButtonPressed(sender: AnyObject) {
        if medToAdd != nil {
            setMedFromGlossary()
        } else {
            print("Error in addMedFromGlossaryButtonPressed")
        }
    }
    
    func setMedFromGlossary() {
        medName.text = medToAdd!.name;
        med.imageUrl = medToAdd!.imageUrl
        med.pageUrl = medToAdd!.pageUrl
        medInfoButton.hidden = false;
        addFromGlossaryButton.hidden = true;
        medAdded = true;
        
        if medToAdd!.image != nil {
            photo!.fullImage = medToAdd!.image
            photo!.image = medToAdd!.croppedImage
            photoContainer!.hidden = false;
            addPhotoButton!.hidden = true;
        }
    }
    
    
    @IBAction func medInfoButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("MedInfoFromMyMed", sender: sender)
    }
    
    @IBAction func medNameChanged(textField: UITextField){
        var found: Bool = false;
        
        if medAdded {
            found = true;
            
        } else if textField.text!.characters.count > 2 {
            for med in medList.medications {
                if med.name.lowercaseString.hasPrefix(textField.text!.lowercaseString){
                    found = true;
                    addFromGlossaryButton.hidden = false;
                    addFromGlossaryButton.setTitle(String(format: "Add %@ from Glossary", arguments: [med.name]), forState: UIControlState.Normal)
                    medToAdd = med;
                }
            }
        }
        if !found {
            addFromGlossaryButton.hidden = true;
            medToAdd = nil;
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == medInstructions {
            if textView.textColor == UIColor.greyPlaceholderColor(){
                textView.text = ""
                textView.textColor = UIColor.blackColor()
            }
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        let trimmedString = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (trimmedString == ""){
            textView.text = "Instructions"
            textView.textColor = UIColor.greyPlaceholderColor()
        }
    }
    
    @IBAction func toggleDiscontinue(){
        if med.discontinued == false {
            med.discontinued = true
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.discontinueButton.backgroundColor = UIColor.visionBlueColor();
                self.discontinueButton.setTitle("Restart", forState: UIControlState.Normal)
            })
            
        } else {
            med.discontinued = false
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.discontinueButton.backgroundColor = UIColor.visionPurpleColor();
                self.discontinueButton.setTitle("Discontinue", forState: UIControlState.Normal)
            })
            
        }
    }
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
    
    override func imageTapped(sender: UITapGestureRecognizer){
        performSegueWithIdentifier("FullImageFromMyMedication", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FullImageFromMyMedication" {
            let imageCtrl: FullImageViewController = segue.destinationViewController as! FullImageViewController;
            
            imageCtrl.image = photo!.fullImage;
            imageCtrl.shouldAutorotate();
            
        } else if segue.identifier == "MedInfoFromMyMed" {
            let navCtrl: UINavigationController = segue.destinationViewController as! UINavigationController
            let infoCtrl: MedPageHTMLViewController = (navCtrl.viewControllers[0]) as! MedPageHTMLViewController;
            
            infoCtrl.myMed = med;
            
        }
    }
    
    override func viewDidLoad() {
        
        for view: UIView in self.mainStackView!.arrangedSubviews {
            for  constraint in view.constraints {
                constraint.priority = 999;
            }
        }
        
        self.medHistoryTable.allowsSelection = false;
        self.medHistoryTable.rowHeight = UITableViewAutomaticDimension;
        self.medHistoryTable.estimatedRowHeight = 60
        self.medHistoryTable.layer.cornerRadius = 5;
        self.medHistoryTable.layer.borderColor = UIColor.greyTextFieldBorderColor().CGColor;
        self.medHistoryTable.layer.borderWidth = 0.5;
//        self.medHistoryTable.scrollEnabled = false;
        
        medList.medications = Data.getAllMedications()
        medHistories = []
        
        medInstructions!.delegate = self
        
//        addPhotoButton!.hidden = true;
//        photoContainer!.hidden = true;
        addFromGlossaryButton.hidden = true;
        medInfoButton.hidden = true;
        
        if (newMode){
            self.title = "New My Medication"
            self.discontinueButton!.hidden = true;
            self.deleteButton!.hidden = true;
            self.medHistoryStack.hidden = true;
            
        } else {
            self.title = "Edit My Medication"
            if (med.discontinued){
                self.discontinueButton.backgroundColor = UIColor.visionBlueColor();
                self.discontinueButton.setTitle("Restart", forState: UIControlState.Normal);
            }
        }
        
        loadFields();
        
        if (medToAdd != nil) {
            setMedFromGlossary()
        }
        
        
        if (medInstructions != nil){
            medInstructions!.layer.cornerRadius = 5;
            medInstructions!.layer.borderColor = UIColor.greyTextFieldBorderColor().CGColor;
            medInstructions!.layer.borderWidth = 0.5;
            if (medInstructions!.text == ""){
                medInstructions!.text = "Instructions"
                medInstructions!.textColor = UIColor.greyPlaceholderColor()
            } else {
                medInstructions!.textColor = UIColor.blackColor()
            }
        }
        
        super.viewDidLoad()
    }
    
    @IBAction func toggleBreakfast(){
        if (breakfastButtonSelected){
            breakfastButtonSelected = false;
            breakfastButton.setImage(UIImage(named: "lightGreyCircle"), forState: UIControlState.Normal);
        } else {
            breakfastButtonSelected = true;
            breakfastButton.setImage(UIImage(named: "blueCircle"), forState: UIControlState.Normal);
        }
    }
    
    @IBAction func toggleLunch(){
        if (lunchButtonSelected){
            lunchButtonSelected = false;
            lunchButton.setImage(UIImage(named: "lightGreyCircle"), forState: UIControlState.Normal);
        } else {
            lunchButtonSelected = true;
            lunchButton.setImage(UIImage(named: "blueCircle"), forState: UIControlState.Normal);
        }
    }
    
    @IBAction func toggleDinner(){
        if (dinnerButtonSelected){
            dinnerButtonSelected = false;
            dinnerButton.setImage(UIImage(named: "lightGreyCircle"), forState: UIControlState.Normal);
        } else {
            dinnerButtonSelected = true;
            dinnerButton.setImage(UIImage(named: "blueCircle"), forState: UIControlState.Normal);
        }
    }
    
    @IBAction func toggleBed(){
        if (bedButtonSelected){
            bedButtonSelected = false;
            bedButton.setImage(UIImage(named: "lightGreyCircle"), forState: UIControlState.Normal);
        } else {
            bedButtonSelected = true;
            bedButton.setImage(UIImage(named: "blueCircle"), forState: UIControlState.Normal);
        }
    }
    
    override func loadFields(){
        
        if (med.image != nil){
            photo!.fullImage = med.image;
            photo!.image = med.croppedImage;
            photoContainer!.hidden = false;
            addPhotoButton!.hidden = true;
            
        } else {
            photoContainer!.hidden = true;
            addPhotoButton!.hidden = false;
        }
        
        if (med.id != "0"){
            medName.text = med.name;
            medInstructions.text = med.instructions;
            
            if (med.breakfast){
                breakfastButtonSelected = true;
                breakfastButton.setImage(UIImage(named: "blueCircle"), forState: UIControlState.Normal);
            } else {
                breakfastButton.setImage(UIImage(named: "lightGreyCircle"), forState: UIControlState.Normal);
            }
            if (med.lunch){
                lunchButtonSelected = true;
                lunchButton.setImage(UIImage(named: "blueCircle"), forState: UIControlState.Normal);
            } else {
                lunchButton.setImage(UIImage(named: "lightGreyCircle"), forState: UIControlState.Normal);
            }
            if (med.dinner){
                dinnerButtonSelected = true;
                dinnerButton.setImage(UIImage(named: "blueCircle"), forState: UIControlState.Normal);
            } else {
                dinnerButton.setImage(UIImage(named: "lightGreyCircle"), forState: UIControlState.Normal);
            }
            if (med.bed){
                bedButtonSelected = true;
                bedButton.setImage(UIImage(named: "blueCircle"), forState: UIControlState.Normal);
            } else {
                bedButton.setImage(UIImage(named: "lightGreyCircle"), forState: UIControlState.Normal);
            }
            
            if (medInstructions!.text == ""){
                medInstructions!.text = "Instructions"
                medInstructions!.textColor = UIColor.greyPlaceholderColor()
            } else {
                medInstructions!.textColor = UIColor.blackColor()
            }
            
            medHistories = Data.getMyMedicationHistory(med.id)
            
        } else {
            // No MyMedication to Load, probably New view
            
        }
    }
    
    func getAddedOrRemoved(buttonSelected: Bool) -> String{
        if (buttonSelected) {
            return "added"
        } else {
            return "removed"
        }
    }
    
    @IBAction func save(sender: UIButton){
        
        // Prevent saving placeholder text as instructions data
        var instructions = medInstructions.text
        if medInstructions!.textColor == UIColor.greyPlaceholderColor() {
            instructions = "";
        }
        
        let medIdFromSave = Data.saveMyMedication(MyMedication(withName: medName.text!, andImage: photo!.fullImage, andCroppedImage: photo!.image, andInstructions: instructions, andId: med.id, andBreakfast: breakfastButtonSelected, andLunch: lunchButtonSelected, andDinner: dinnerButtonSelected, andBed: bedButtonSelected, andDate: med.date, andDiscontinued: med.discontinued));
        
        
        var historyText: String = "";
        var timeChanged = false;
        
        if (med.breakfast != breakfastButtonSelected){
            historyText += "Breakfast time \(getAddedOrRemoved(breakfastButtonSelected))"
            timeChanged = true;
        }
        if (med.lunch != lunchButtonSelected){
            if (timeChanged) {
                historyText += ", "
            }
            historyText += "Lunch time \(getAddedOrRemoved(lunchButtonSelected))"
            timeChanged = true;
        }
        if (med.dinner != dinnerButtonSelected){
            if (timeChanged) {
                historyText += ", "
            }
            historyText += "Dinner time \(getAddedOrRemoved(dinnerButtonSelected))"
            timeChanged = true;
        }
        if (med.bed != bedButtonSelected){
            if (timeChanged) {
                historyText += ", "
            }
            historyText += "Bed time \(getAddedOrRemoved(bedButtonSelected))"
        }
        
        if (medInstructions.text != med.instructions){
            if (timeChanged) {
                historyText += "\n"
            }
            historyText += medInstructions.text;
        }
        if (historyText != ""){
            Data.saveMyMedicationHistory(MyMedicationHistory(withId: "0", andMedId: medIdFromSave, andDate: NSDate(), andText: historyText))
        }
        
        
        //delegate!.itemSaved = true;
        
        self.dismissViewControllerAnimated(true, completion: nil)

        
//        if (date != StaticDates.sharedInstance.defaultDate){
////            let notes: String = (notesField!.textColor == UIColor.greyPlaceholderColor()) ? "" : notesField!.text;
////            let myMedicationId: String =
//
//            
////            delegate?.itemToScrollToId = myMedicationId
//            
//        } else {
//            dateField!.shake(10, delta: 10, speed: 0.1);
//        }
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medHistories!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MedHistoryCell", forIndexPath: indexPath) as! MedHistoryTableViewCell
        
        let medHistory = medHistories![indexPath.row];
        cell.medHistory = medHistory;
        
        cell.dateLabel.text = medHistory.date.dayMonthFormat();
        cell.historyTextLabel.text = medHistory.text;
        
        if medHistoryTable.contentSize.height > 250 {
            tableHeight.constant = 250;
        }
        if tableHeight.constant < 250 {
            let newHeight = medHistoryTable.contentSize.height + 20
            tableHeight.constant = newHeight > 250 ? 250 : newHeight;
        }

        
        return cell
    }

}
