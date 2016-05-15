//
//  SymptomTagViewController.swift
//  Vision Project
//
//  Created by Andrew on 6/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomTagViewController: AGInputViewController, SymptomTagCellDelegate {
    
    @IBOutlet weak var symptomTagsCollection: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    var symptomTags: [SymptomTag]?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        symptomTags = SymptomTags().tags;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(sender: UIButton){
        
        for subview in symptomTagsCollection.subviews {
            if let symptomTagCell = subview as? SymptomTagCollectionViewCell{
                Data.saveSymptomTag(SymptomTag(withId: symptomTagCell.symptomTag!.id, andColor: symptomTagCell.symptomTag!.color, andName: symptomTagCell.nameField!.text!, andEnabled: symptomTagCell.switchy.on));
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func toggleSymptomTag(sender: SymptomTagCollectionViewCell){
        //Nothing to do?
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
        
        let symptomTag = symptomTags![indexPath.row];
        cell.delegate = self;
        cell.symptomTag = symptomTag;
        if (symptomTag.enabled) {
            cell.switchy.setOn(true, animated: false);
        } else {
            cell.switchy.setOn(false, animated: false);
        }
        
        cell.switchy.userInteractionEnabled = false;
        
        cell.nameField!.text = symptomTag.name;
        cell.colorView.backgroundColor = symptomTag.color;
        
        collectionHeight.constant = collectionView.contentSize.height;
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 41)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
