
//
//  SymptomTableViewCell.swift
//  Vision Project
//
//  Created by Andrew on 6/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var symptomTextLabel: UILabel!
    
    @IBOutlet weak var symptomTagStack: UIStackView!
    
    var symptom: Symptom?;
    var delegate: SymptomCellDelegate?;
    
    @IBAction func editSymptom(sender: AnyObject) {
        delegate!.editSymptom(self);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
