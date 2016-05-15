//
//  SymptomTagViewController.swift
//  Vision Project
//
//  Created by Andrew on 6/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomTagViewController: AGInputViewController, SymptomTagCellDelegate {

    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet weak var symptomTagsCollection: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        cell.switchy.setOn(true, animated: false);
        
        cell.switchy.userInteractionEnabled = false;
        
        cell.nameLabel.text = symptomTag.name;
        cell.colorView.backgroundColor = symptomTag.color;
        
        collectionHeight.constant = collectionView.contentSize.height;
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
