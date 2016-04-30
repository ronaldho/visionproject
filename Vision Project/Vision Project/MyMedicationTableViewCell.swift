//
//  MyMedicationTableViewCell.swift
//  Vision Project
//
//  Created by Andrew on 26/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MyMedicationTableViewCell: UITableViewCell {

    var delegate: MyMedicationCellDelegate!;
    var myMedication: MyMedication!;
    
    @IBOutlet var medImage: UIImageView!;
    @IBOutlet var medName: UILabel!;
    @IBOutlet var breakfastView: UIView!;
    @IBOutlet var lunchView: UIView!;
    @IBOutlet var dinnerView: UIView!;
    @IBOutlet var bedView: UIView!;
    @IBOutlet var medInfo: UILabel!;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
