//
//  MyMedicationTableViewCell.swift
//  EMIT Project
//
//  Created by Andrew on 26/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    var delegate: FilterCellDelegate!;
    
    @IBOutlet var breakfastView: UIView!;
    @IBOutlet var lunchView: UIView!;
    @IBOutlet var dinnerView: UIView!;
    @IBOutlet var bedView: UIView!;
    
    @IBAction func breakfastTapped(){
        
    }
    @IBAction func lunchTapped(){
        
    }
    @IBAction func dinnerTapped(){
        
    }
    @IBAction func bedTapped(){
        
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
