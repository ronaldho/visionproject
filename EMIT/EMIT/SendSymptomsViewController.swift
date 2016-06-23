//
//  SendSymptomsViewController.swift
//  EMIT Project
//
//  Created by Andrew on 9/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import MessageUI
import UIKit

class SendSymptomsViewController: AGInputViewController, SymptomTagCellDelegate, UIActivityItemSource {
    
    @IBOutlet var startDateField: UITextField!;
    @IBOutlet var endDateField: UITextField!;
    @IBOutlet var sendEmailButton: UIButton!;
    @IBOutlet var sendGmailButton: UIButton!;
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var selectNoneButton: UIButton!
    @IBOutlet weak var tagsContainer: UIView!
    
    @IBOutlet weak var symptomTagsCollection: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBAction func selectAllButtonPressed(sender: AnyObject) {
        for view in symptomTagsCollection.subviews {
            if let cell = view as? SymptomTagCollectionViewCell {
                cell.selectSymptomTag(self, newState: true)
            }
        }
    }

    @IBAction func selectNoneButtonPressed(sender: AnyObject) {
        for view in symptomTagsCollection.subviews {
            if let cell = view as? SymptomTagCollectionViewCell {
                cell.selectSymptomTag(self, newState: false)
            }
        }
    }
    
    var allSymptoms: Symptoms?;
    var startDate: NSDate?;
    var endDate: NSDate?
    var symptomTags: [SymptomTag]?;
    
    var ms: MailSender?;
    
    func filteredSymptoms() -> Symptoms {
        if allSymptoms != nil {
            var selectedSymptomTags: [SymptomTag] = []
            for view in symptomTagsCollection.subviews {
                if let cell = view as? SymptomTagCollectionViewCell {
                    if cell.tagSelected! {
                        selectedSymptomTags.append(cell.symptomTag!)
//                        print("\(cell.symptomTag!.name) enabled")
                    }
                }
            }
            
            
            let filteredSymptoms: Symptoms = Symptoms();
            for symptom in allSymptoms!.symptoms {
                
                var startDateComparison: NSComparisonResult?
                var endDateComparison: NSComparisonResult?
                
                if startDate != nil {
                    startDateComparison = NSCalendar.currentCalendar().compareDate(startDate!, toDate:symptom.date, toUnitGranularity: .Day)
                }
                
                if endDate != nil {
                    endDateComparison = NSCalendar.currentCalendar().compareDate(endDate!, toDate:symptom.date, toUnitGranularity: .Day)
                }
                
                if startDate == nil || startDateComparison == NSComparisonResult.OrderedAscending || startDateComparison == NSComparisonResult.OrderedSame {
                    
                    if endDate == nil || endDateComparison == NSComparisonResult.OrderedDescending || endDateComparison == NSComparisonResult.OrderedSame {
                        
                        if selectedSymptomTags.count > 0 {
                            for symptomTag in selectedSymptomTags {
                                if symptom.hasSymptomTag(symptomTag){
                                    if !filteredSymptoms.symptoms.contains(symptom){
                                        filteredSymptoms.symptoms.append(symptom);
                                    }
                                }
                            }
                        } else {
                            if !filteredSymptoms.symptoms.contains(symptom){
                                filteredSymptoms.symptoms.append(symptom);
                            }
                        }
                        
                    }
                }
            }
            
            return filteredSymptoms
            
        } else {
            print("allSymptoms is nil");
        }
        
        return Symptoms();
    }
    
    @IBAction override func dateTextInputPressed(sender: UITextField) {
        
        //Create the view
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        
        var datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        configureDatePicker(&datePickerView)
        
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
        if (sender == startDateField){
            doneButton.addTarget(self, action: #selector(SendSymptomsViewController.doneButtonStart(_:)), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
            
            datePickerView.addTarget(self, action: #selector(SendSymptomsViewController.handleStartDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
            handleStartDatePicker(datePickerView) // Set the date
        } else if (sender == endDateField){
            doneButton.addTarget(self, action: #selector(SendSymptomsViewController.doneButtonEnd(_:)), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
            
            datePickerView.addTarget(self, action: #selector(SendSymptomsViewController.handleEndDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
            handleEndDatePicker(datePickerView) // Set the date
        }

        
        
    }
    
    func handleStartDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = getDateFormat()
        startDateField!.text = dateFormatter.stringFromDate(sender.date)
        startDate = sender.date;
    }
    
    func handleEndDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = getDateFormat()
        endDateField!.text = dateFormatter.stringFromDate(sender.date)
        endDate = sender.date;
    }
    
    func doneButtonStart(sender:UIButton)
    {
        startDateField!.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func doneButtonEnd(sender:UIButton)
    {
        endDateField!.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    @IBAction func onSendPressed(sender: UIButton) {
        
        let objectsToShare = [self]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAirDrop, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypeOpenInIBooks, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTwitter, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll]
        
        //            activityVC.setValue("My Medication List", forKey: "subject")
        
        activityVC.popoverPresentationController?.sourceView = sender
        activityVC.popoverPresentationController?.sourceRect = sender.bounds
        self.presentViewController(activityVC, animated: true, completion: nil)
//        
//        
//        ms = MailSender(parentVC: self);
//        
//        let title = "Symptoms"
//        let messageBody = filteredSymptoms().toEmailString();
//        //let toRecipents = ["foo@bar.com"]
//        
//        if (sender == self.sendGmailButton){
//            let gmailString: String = String("googlegmail:///co?subject=\(title)&body=\(messageBody)");
//            let urlString = gmailString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet());
//            let gmailURL: NSURL = NSURL(string: urlString!)!;
//            
//            UIApplication.sharedApplication().openURL(gmailURL);
//            
//        } else if (sender == self.sendEmailButton) {
//            ms?.send(title, messageBody: messageBody, toRecipents: []);
//        }
    }
    
    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
//        return myMedications.toShareString()
        return filteredSymptoms().toEmailString();
    }
    
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
//        if activityType == UIActivityTypeMail {
//            return myMedications.toHTMLTable()
//        } else {
//            return myMedications.toShareString()
//        }
        return filteredSymptoms().toEmailString()
    }
    
    
    
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
        cell.backgroundSelectedView!.backgroundColor = UIColor.EMITLightGreenColor()
        cell.tagSelected = true;
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        symptomTags = SymptomTags().enabledTags;

        tagsContainer.layer.borderColor = UIColor.darkGrayColor().CGColor
        tagsContainer.layer.borderWidth = 1
        tagsContainer.layer.cornerRadius = 5
        
        selectAllButton.tintColor = UIColor.blackColor()
        selectAllButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        selectAllButton.layer.borderWidth = 1
        selectAllButton.layer.cornerRadius = 5
        selectNoneButton.tintColor = UIColor.blackColor()
        selectNoneButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        selectNoneButton.layer.borderWidth = 1
        selectNoneButton.layer.cornerRadius = 5
        
        sendEmailButton.backgroundColor = UIColor.mailBlueColor();
        
        ms = MailSender(parentVC: self);
        if (ms!.gmailInstalled()){
            sendGmailButton.hidden = false;
            sendGmailButton.backgroundColor = UIColor.gmailRedColor();
        } else {
            sendGmailButton.hidden = true;
        }
        
        sendEmailButton.setTitle("Send", forState: UIControlState.Normal)
        sendEmailButton.backgroundColor = UIColor.EMITLightGreenColor()
        sendGmailButton.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
