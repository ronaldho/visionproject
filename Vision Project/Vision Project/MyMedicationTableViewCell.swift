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
    @IBOutlet var breakfastImage: UIImageView!;
    @IBOutlet var lunchImage: UIImageView!;
    @IBOutlet var dinnerImage: UIImageView!;
    @IBOutlet var bedImage: UIImageView!;
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
