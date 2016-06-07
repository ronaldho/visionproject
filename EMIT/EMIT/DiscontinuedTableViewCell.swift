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
    @IBOutlet weak var startedDateLabel: UILabel!
    @IBOutlet weak var stoppedDateLabel: UILabel!
    @IBOutlet weak var startedDateStack: UIStackView!
    @IBOutlet weak var stoppedDateStack: UIStackView!
    
    var med: MyMedication?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
