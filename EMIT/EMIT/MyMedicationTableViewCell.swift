//
//  MyMedicationTableViewCell.swift
//  EMIT Project
//
//  Created by Andrew on 26/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MyMedicationTableViewCell: UITableViewCell {

    var delegate: MyMedicationCellDelegate!;
    var myMedication: MyMedication!;
    
    @IBOutlet var medImage: AGImageView!;
    @IBOutlet var medName: UILabel!;
    @IBOutlet var breakfastImage: UIImageView!;
    @IBOutlet var lunchImage: UIImageView!;
    @IBOutlet var dinnerImage: UIImageView!;
    @IBOutlet var bedImage: UIImageView!;
    @IBOutlet var medInstructions: UILabel!;
    @IBOutlet weak var nameBackground: UIView!
    
    
    @IBAction func editMed(){
        self.delegate.editMed(self);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
