//
//  SymptomTagCollectionViewCell.swift
//  EMIT Project
//
//  Created by Andrew on 7/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomTagCollectionViewCell: UICollectionViewCell {
    @IBOutlet var switchy: UISwitch?;
    @IBOutlet var colorView: UIView!;
    @IBOutlet var nameLabel: UILabel?;
    @IBOutlet var nameField: UITextField?;
    @IBOutlet var stackView: UIStackView!;
    @IBOutlet var backgroundSelectedView: UIView?;
    
    var tagSelected: Bool?
    var symptomTag: SymptomTag?;
    var delegate: SymptomTagCellDelegate?;
    
    func selectSymptomTag(sender: AnyObject?){
        if (tagSelected != nil && backgroundSelectedView != nil) {
            if (tagSelected!) {
                tagSelected = false;
                backgroundSelectedView!.backgroundColor = UIColor.clearColor()
            } else {
                tagSelected = true;
                backgroundSelectedView!.backgroundColor = UIColor.EMITLightGreenColor()
            }
        }
    }
    
    func enableOrDisableSymptomTag(sender: AnyObject?){
        if (switchy!.on){
            switchy!.setOn(false, animated: true);
        } else {
            switchy!.setOn(true, animated: true);
        }
    }
    
    
}
