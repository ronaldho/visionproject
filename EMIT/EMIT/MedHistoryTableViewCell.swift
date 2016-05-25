//
//  SymptomTagCollectionViewCell.swift
//  EMIT Project
//
//  Created by Andrew on 7/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MedHistoryTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!;
    @IBOutlet var historyTextLabel: UILabel!;
    @IBOutlet var stackView: UIStackView!;
    
    var medHistory: MyMedicationHistory?;
    
}
