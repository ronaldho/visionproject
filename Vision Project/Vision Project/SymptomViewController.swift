//
//  SymptomViewController.swift
//  Vision Project
//
//  Created by Andrew on 6/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

protocol SymptomTagCellDelegate{
    func toggleSymptomTag(sender: SymptomTagCollectionViewCell);
}

class SymptomViewController: AGInputViewController , SymptomTagCellDelegate{

    @IBOutlet weak var detailsText: UITextView!
    @IBOutlet weak var symptomTagsCollection: UICollectionView!

    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    var delegate: InputViewDelegate?;
    var savedApptId: String = "";
    var symptom: Symptom = Symptom();
    
    func toggleSymptomTag(sender: SymptomTagCollectionViewCell) {
        var indexToRemove: Int = -1;
        var found: Bool = false;
        if (symptom.tagIDs.count > 0){
            for i in 0...symptom.tagIDs.count-1 {
                if (symptom.tagIDs[i] == sender.symptomTag!.id){
                    indexToRemove = i;
                    found = true;
                }
            }
        }
        if (indexToRemove != -1){
            symptom.tagIDs.removeAtIndex(indexToRemove);
        }
        if (!found){
            symptom.tagIDs.append(sender.symptomTag!.id);
        }
        print(symptom.tagIDs);
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let cell: SymptomTagCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)! as! SymptomTagCollectionViewCell;
        
        cell.toggleSymptomTag(self);
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SymptomTags().tags.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SymptomTagCell", forIndexPath: indexPath) as! SymptomTagCollectionViewCell
        
        let symptomTag = SymptomTags().tags[indexPath.row];
        cell.delegate = self;
        cell.symptomTag = symptomTag;
        if (symptom.hasTagID(symptomTag.id)){
            cell.switchy.setOn(true, animated: false);
        } else {
            cell.switchy.setOn(false, animated: false);
        }
        cell.switchy.userInteractionEnabled = false;
        
        cell.nameLabel.text = symptomTag.name;
        cell.colorView.backgroundColor = symptomTag.color;
        
        collectionHeight.constant = collectionView.contentSize.height;
        
        return cell
    }

    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.greyPlaceholderColor(){
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        let trimmedString = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (trimmedString == ""){
            textView.text = "Instructions"
            textView.textColor = UIColor.greyPlaceholderColor()
        }
    }
    
    @IBAction func deleteSymptom(){
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let delete = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
            Data.deleteSymptom(self.symptom);
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imageTapped(sender: UITapGestureRecognizer){
        performSegueWithIdentifier("FullImageFromSymptom", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FullImageFromSymptom" {
            let imageCtrl: FullImageViewController = segue.destinationViewController as! FullImageViewController;
            
            imageCtrl.image = photo!.fullImage;
            imageCtrl.shouldAutorotate();
        }
    }
    
    override func viewDidLoad() {
        addPhotoButton!.hidden = true;
        photoContainer!.hidden = true;
        
        if (newMode){
            self.title = "New Symptom"
            self.deleteButton!.hidden = true;
        } else {
            self.title = "Edit Symptom"
        }
        
        loadFields();
        
        if (detailsText != nil){
            detailsText!.delegate = self
            detailsText!.layer.cornerRadius = 5;
            detailsText!.layer.borderColor = UIColor.greyTextFieldBorderColor().CGColor;
            detailsText!.layer.borderWidth = 0.5;
            if (detailsText!.text == ""){
                detailsText!.text = "Instructions"
                detailsText!.textColor = UIColor.greyPlaceholderColor()
            } else {
                detailsText!.textColor = UIColor.blackColor()
            }
        }
        
        super.viewDidLoad()
    }
    
    override func loadFields(){
        if (symptom.id != "0"){
            detailsText.text = symptom.text;
            
            if (detailsText!.text == ""){
                detailsText!.text = "Instructions"
                detailsText!.textColor = UIColor.greyPlaceholderColor()
            } else {
                detailsText!.textColor = UIColor.blackColor()
            }
            
//            if (symptom.image != nil){
//                photo!.fullImage = symptom.image;
//                photo!.image = symptom.croppedImage;
//                photoContainer!.hidden = false;
//                addPhotoButton!.hidden = true;
//            } else {
//                photoContainer!.hidden = true;
//                addPhotoButton!.hidden = false;
//            }
        } else {
            // No Symptom to Load, probably New view
        }
    }
    
    @IBAction func save(sender: UIButton){
        
        Data.saveSymptom(Symptom(withId: symptom.id, andDate: symptom.date, andText: detailsText.text, andTagIDs: symptom.tagIDs, andImage: symptom.image, andCroppedImage: symptom.croppedImage));
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


}
