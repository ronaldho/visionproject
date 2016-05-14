//
//  CalendarDayCell.swift
//  Vision Project
//
//  Created by Andrew on 11/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {
    @IBOutlet var dayLabel: UILabel!;
    @IBOutlet var view: UIView!;
    @IBOutlet var indicatorView: UIView!;
    
    var date: NSDate!;
}
