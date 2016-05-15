//
//  AGInputViewController.swift
//  Vision Project
//
//  Created by Andrew on 30/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import Foundation
import UIKit
class AGInputViewController: AGViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextViewDelegate  {
    
    @IBOutlet var dateField: UITextField?;
    @IBOutlet var notesField: UITextView?;
    @IBOutlet var photo: AGImageView?;
    @IBOutlet var addPhotoButton: UIButton?;
    @IBOutlet var photoContainer: UIView?;
    @IBOutlet var deleteButton: UIButton?;
    @IBOutlet var mainStackView: UIStackView?;
    
    var datePicker: UIDatePicker?;
    var date: NSDate = StaticDates.sharedInstance.defaultDate;
    var imagePicker: UIImagePickerController!
    var newMode: Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (photo != nil){
            photo!.userInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AGInputViewController.imageTapped(_:)))
            photo!.addGestureRecognizer(tapRecognizer);
            photoContainer!.hidden = true;
        }
        loadFields();
    }
    
    func imageTapped(sender: UITapGestureRecognizer){
        
    }
    
    func loadFields(){
        // Override in subclasses
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        photo!.fullImage = info[UIImagePickerControllerOriginalImage] as? UIImage;
        photo!.image = ImageUtils.cropToSquare(ImageUtils.fixOrientation(photo!.fullImage!));
    }
    
    func takePhoto(){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        photoContainer!.hidden = false;
        addPhotoButton!.hidden = true;
    }
    
    func selectPhotoFromLibrary(){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        photoContainer!.hidden = false;
        addPhotoButton!.hidden = true;
    }
    
    @IBAction func addPhoto(sender: UIButton){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let appointment = UIAlertAction(title: "Take Photo", style: .Default, handler: { (action) -> Void in
            self.takePhoto();
        })
        let entry = UIAlertAction(title: "Choose Photo", style: .Default, handler: { (action) -> Void in
            self.selectPhotoFromLibrary();
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(appointment)
        alertController.addAction(entry)
        alertController.addAction(cancel)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func deletePhoto(sender: UIButton){
        photo!.image = nil;
        photoContainer!.hidden = true;
        addPhotoButton!.hidden = false;
    }
    
    @IBAction func cancel(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dateTextInputPressed(sender: UITextField) {
        
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
        
        doneButton.addTarget(self, action: #selector(AGInputViewController.doneButton(_:)), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(AGInputViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView) // Set the date on start.
    }
    
    func configureDatePicker(inout picker: UIDatePicker){
        picker.datePickerMode = UIDatePickerMode.Date
        picker.setDate((date == StaticDates.sharedInstance.defaultDate) ? NSDate() : date, animated: true)
    }
    
    func getDateFormat() -> String{
        return "MMMM d"
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = getDateFormat()
        dateField!.text = dateFormatter.stringFromDate(sender.date)
        date = sender.date;
    }
    
    func doneButton(sender:UIButton)
    {
        dateField!.resignFirstResponder() // To resign the inputView on clicking done.
    }
}
