//
//  DiscontinuedTableViewCell.swift
//  EMIT Project
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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
