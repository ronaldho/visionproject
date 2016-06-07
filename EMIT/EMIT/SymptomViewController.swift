//
//  SymptomViewController.swift
//  EMIT Project
//
//  Created by Andrew on 6/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

protocol SymptomTagCellDelegate{
//    func toggleSymptomTag(sender: SymptomTagCollectionViewCell);
}

class SymptomViewController: AGInputViewController , SymptomTagCellDelegate{

    @IBOutlet weak var detailsText: UITextView!
    @IBOutlet weak var symptomTagsCollection: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var tagLabelSpacerViewWidth: NSLayoutConstraint!
    
    var delegate: InputViewDelegate?;
    var savedApptId: String = "";
    var symptom: Symptom = Symptom();
    var symptomTags: [SymptomTag]?;
    
    
//    func toggleSymptomTag(sender: SymptomTagCollectionViewCell) {
//        var indexToRemove: Int = -1;
//        var found: Bool = false;
//        if (symptom.tagIDs.count > 0){
//            for i in 0...symptom.tagIDs.count-1 {
//                if (symptom.tagIDs[i] == sender.symptomTag!.id){
//                    indexToRemove = i;
//                    found = true;
//                }
//            }
//        }
//        if (indexToRemove != -1){
//            symptom.tagIDs.removeAtIndex(indexToRemove);
//        }
//        if (!found){
//            symptom.tagIDs.append(sender.symptomTag!.id);
//        }
//    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let cell: SymptomTagCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)! as! SymptomTagCollectionViewCell;
        
        cell.selectSymptomTag(self, newState: nil);
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SymptomTags().enabledTags.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SymptomTagCell", forIndexPath: indexPath) as! SymptomTagCollectionViewCell
        
        let symptomTag = symptomTags![indexPath.row];
        cell.delegate = self;
        cell.symptomTag = symptomTag;
        if (symptom.hasSymptomTag(symptomTag)){
            cell.backgroundSelectedView!.backgroundColor = UIColor.EMITLightGreenColor()
            cell.tagSelected = true;
        } else {
            cell.backgroundSelectedView!.backgroundColor = UIColor.clearColor()
            cell.tagSelected = false;
        }

        cell.nameLabel!.text = symptomTag.name;
        cell.colorView.backgroundColor = symptomTag.color;
        
        collectionHeight.constant = collectionView.contentSize.height;
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width, height: 41)
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
            textView.text = "Details"
            textView.textColor = UIColor.greyPlaceholderColor()
        }
    }
    
    
    @IBAction func editSymptomTags(sender: UIButton) {
        performSegueWithIdentifier("EditSymptomTags", sender: sender)
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
        
        alertController.popoverPresentationController?.sourceView = deleteButton
        alertController.popoverPresentationController?.sourceRect = (deleteButton?.bounds)!
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func imageTapped(sender: UITapGestureRecognizer){
        performSegueWithIdentifier("FullImageFromSymptom", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FullImageFromSymptom" {
            let imageCtrl: FullImageViewController = segue.destinationViewController as! FullImageViewController;
            
            imageCtrl.image = photo!.fullImage;
            imageCtrl.shouldAutorotate();
        }
    }
    
    override func viewDidLayoutSubviews() {
        tagLabelSpacerViewWidth.constant = (mainStackView!.bounds.width-50)/2;
        
    }
    
    override func viewDidLoad() {
        
        if (newMode){
            self.title = "New Symptom"
            self.deleteButton!.hidden = true;
        } else {
            self.title = "Edit Symptom"
        }
        
        symptomTags = SymptomTags().enabledTags;

        loadFields();
        
        if (detailsText != nil){
            detailsText!.delegate = self
            detailsText!.layer.cornerRadius = 5;
            detailsText!.layer.borderColor = UIColor.greyTextFieldBorderColor().CGColor;
            detailsText!.layer.borderWidth = 0.5;
            if (detailsText!.text == ""){
                detailsText!.text = "Details"
                detailsText!.textColor = UIColor.greyPlaceholderColor()
            } else {
                detailsText!.textColor = UIColor.blackColor()
            }
        }
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        symptomTags = SymptomTags().enabledTags;
        symptomTagsCollection.reloadData();
    }
    
    override func loadFields(){
        if (symptom.id != "0"){
            detailsText.text = symptom.text;
            date = symptom.date;
            dateField!.text = symptom.date.dayMonthFormat();
            
            if (detailsText!.text == ""){
                detailsText!.text = "Details"
                detailsText!.textColor = UIColor.greyPlaceholderColor()
            } else {
                detailsText!.textColor = UIColor.blackColor()
            }
            
            if (symptom.image != nil){
                photo!.fullImage = symptom.image;
                photo!.image = symptom.croppedImage;
                photoContainer!.hidden = false;
                addPhotoButton!.hidden = true;
            } else {
                photoContainer!.hidden = true;
                addPhotoButton!.hidden = false;
            }
        } else {
            // No Symptom to Load, probably New view
        }
    }
    
    @IBAction func save(sender: UIButton){
        
        if (dateField!.text != ""){
            if (detailsText.textColor != UIColor.greyPlaceholderColor() &&
                detailsText.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) != "") {
                
                var selectedSymptomTags: [SymptomTag] = []
                for view in symptomTagsCollection.subviews {
                    if let cell = view as? SymptomTagCollectionViewCell {
                        if cell.tagSelected! {
                            selectedSymptomTags.append(cell.symptomTag!)
                        }
                    }
                }
                
                Data.saveSymptom(Symptom(withId: symptom.id, andDate: date, andText: detailsText.text, andSymptomTags: selectedSymptomTags, andImage: photo!.fullImage, andCroppedImage: photo!.image));
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                detailsText.shake(10, delta: 10, speed: 0.1)
            }
            
        } else {
            dateField!.shake(10, delta: 10, speed: 0.1);
        }
    }
    
    override func configureDatePicker(inout picker: UIDatePicker){
        picker.datePickerMode = UIDatePickerMode.Date
        //picker.minuteInterval = 5;
        
        let calendar = NSCalendar.currentCalendar();
        let components = calendar.components([.Year,.Month,.Day], fromDate: NSDate());
        //components.hour = 12;
        let newDate: NSDate = calendar.dateFromComponents(components)!;
        
        picker.setDate((date == StaticDates.sharedInstance.defaultDate) ? newDate : date, animated: true)
    }

}
