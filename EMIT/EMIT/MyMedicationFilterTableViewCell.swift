//
//  MyMedicationTableViewCell.swift
//  EMIT Project
//
//  Created by Andrew on 26/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class MyMedicationFilterTableViewCell: UITableViewCell {

    var delegate: FilterCellDelegate!;
    
    @IBOutlet var breakfastButton: UIButton!;
    @IBOutlet var lunchButton: UIButton!;
    @IBOutlet var dinnerButton: UIButton!;
    @IBOutlet var bedButton: UIButton!;
    
    var selectedTime: TimeOfDay?
    let unselectedColor = UIColor.EMITMediumGreyColor()
    let breakfastColor = UIColor.morningColor()
    let lunchColor = UIColor.noonColor()
    let dinnerColor = UIColor.sunsetColor()
    let bedColor = UIColor.moonColor()
    
    func toggleButton(time: TimeOfDay) {
        
        breakfastButton.tintColor = unselectedColor;
        lunchButton.tintColor = unselectedColor;
        dinnerButton.tintColor = unselectedColor;
        bedButton.tintColor = unselectedColor;
        
        if time == selectedTime {
            delegate.filterMedList(nil)
            selectedTime = nil
        } else {
            delegate.filterMedList(time)
            selectedTime = time
            switch (time) {
            case .Breakfast:
                breakfastButton.tintColor = breakfastColor
            case .Lunch:
                lunchButton.tintColor = lunchColor
            case .Dinner:
                dinnerButton.tintColor = dinnerColor
            case .Bed:
                bedButton.tintColor = bedColor
            }
        }
    }
    
    @IBAction func toggleBreakfast(){
        toggleButton(TimeOfDay.Breakfast)
    }
    
    @IBAction func toggleLunch(){
        toggleButton(TimeOfDay.Lunch)
    }
    
    @IBAction func toggleDinner(){
        toggleButton(TimeOfDay.Dinner)
    }
    
    @IBAction func toggleBed(){
        toggleButton(TimeOfDay.Bed)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
