//
//  SendViewController.swift
//  EMIT Project
//
//  Created by Andrew on 9/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import MessageUI
import UIKit

class SendViewController: AGInputViewController, SymptomTagCellDelegate {
    
    @IBOutlet var startDateField: UITextField!;
    @IBOutlet var endDateField: UITextField!;
    @IBOutlet var sendEmailButton: UIButton!;
    @IBOutlet var sendGmailButton: UIButton!;
    
    @IBOutlet weak var symptomTagsCollection: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
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
                        print("\(cell.symptomTag!.name) enabled")
                    }
                }
            }
            
            
            let filteredSymptoms: Symptoms = Symptoms();
            for symptom in allSymptoms!.symptoms {
                if startDate == nil || NSCalendar.currentCalendar().compareDate(startDate!, toDate:symptom.date, toUnitGranularity: .Day) == NSComparisonResult.OrderedAscending {
                    
                    if endDate == nil || NSCalendar.currentCalendar().compareDate(endDate!, toDate:symptom.date, toUnitGranularity: .Day) == NSComparisonResult.OrderedDescending {
                        
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
            doneButton.addTarget(self, action: #selector(SendViewController.doneButtonStart(_:)), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
            
            datePickerView.addTarget(self, action: #selector(SendViewController.handleStartDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
            handleStartDatePicker(datePickerView) // Set the date
        } else if (sender == endDateField){
            doneButton.addTarget(self, action: #selector(SendViewController.doneButtonEnd(_:)), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
            
            datePickerView.addTarget(self, action: #selector(SendViewController.handleEndDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
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
        ms = MailSender(parentVC: self);
        
        let title = "Symptoms"
        let messageBody = filteredSymptoms().toEmailString();
        //let toRecipents = ["foo@bar.com"]
        
        if (sender == self.sendGmailButton){
            let gmailString: String = String("googlegmail:///co?subject=\(title)&body=\(messageBody)");
            let urlString = gmailString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet());
            let gmailURL: NSURL = NSURL(string: urlString!)!;
            
            UIApplication.sharedApplication().openURL(gmailURL);
            
        } else if (sender == self.sendEmailButton) {
            ms?.send(title, messageBody: messageBody, toRecipents: []);
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let cell: SymptomTagCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)! as! SymptomTagCollectionViewCell;
        
        cell.selectSymptomTag(self);
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

        sendEmailButton.backgroundColor = UIColor.mailBlueColor();
        
        ms = MailSender(parentVC: self);
        if (ms!.gmailInstalled()){
            sendGmailButton.hidden = false;
            sendGmailButton.backgroundColor = UIColor.gmailRedColor();
        } else {
            sendGmailButton.hidden = true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}