//
//  SymptomTagCollectionViewCell.swift
//  Vision Project
//
//  Created by Andrew on 7/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomTagCollectionViewCell: UICollectionViewCell {
    @IBOutlet var switchy: UISwitch!;
    @IBOutlet var colorView: UIView!;
    @IBOutlet var nameLabel: UILabel!;
    @IBOutlet var nameField: UITextField?;
    @IBOutlet var stackView: UIStackView!;
    
    var symptomTag: SymptomTag?;
    var delegate: SymptomTagCellDelegate?;
    
    func toggleSymptomTag(sender: AnyObject?){
        if (switchy.on){
            switchy.setOn(false, animated: true);
        } else {
            switchy.setOn(true, animated: true);
        }
        delegate!.toggleSymptomTag(self);
    }
    
    
}
