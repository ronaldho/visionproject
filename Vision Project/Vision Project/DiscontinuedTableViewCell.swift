//
//  DiscontinuedTableViewCell.swift
//  Vision Project
//
//  Created by Andrew on 16/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class DiscontinuedTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!;
    var med: MyMedication?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
