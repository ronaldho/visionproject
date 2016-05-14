//
//  SymptomCalendarViewController.swift
//  Vision Project
//
//  Created by Andrew on 11/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomCalendarViewController: UIViewController {

    @IBOutlet var monthLabel: UILabel!;
    @IBOutlet var calendar: UICollectionView!;
    @IBOutlet weak var calendarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var calendarWidthConstraint: NSLayoutConstraint!;
    
    var symptoms: Symptoms = Symptoms();
    var delegate: CalendarViewDelegate?;
    var selectedCell: CalendarDayCell?;
//    var currentMonth: Calendar.Month;
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let cell: CalendarDayCell = collectionView.cellForItemAtIndexPath(indexPath)! as! CalendarDayCell;
        
        if (selectedCell != nil){
            selectedCell!.backgroundColor = UIColor.whiteColor();
        }
        
        cell.backgroundColor = UIColor.visionLightGreenColor();
        selectedCell = cell;
        
        delegate?.dateChanged(cell.date);
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let headerCellCount = 7;
        let spacerCellCount = getWeekdayOfDate(getFirstDayOfMonth()) - 1;
        let dayCellCount = getDaysInMonth();
        return headerCellCount + spacerCellCount + dayCellCount;
    }
    
    func getFirstDayOfMonth() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let dateComponents2 = NSDateComponents()
        dateComponents2.month = 1
        
        let nextMonth = calendar.dateByAddingComponents(dateComponents2, toDate: NSDate(), options: [])!
        
        let components = calendar.components([.Year, .Month], fromDate: nextMonth);
        

        let startOfMonth = calendar.dateFromComponents(components)!
        return startOfMonth;
    }
    
    func getDaysInMonth() -> Int {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: getFirstDayOfMonth(), options: [])!
        let daysInMonth = calendar.components(.Day, fromDate: endOfMonth);
        return daysInMonth.day;

    }
    
    func getWeekdayOfDate(date: NSDate) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: date)
        return myComponents.weekday;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let spacerCellCount = getWeekdayOfDate(getFirstDayOfMonth()) - 1;

        let screenSize: CGRect = UIScreen.mainScreen().bounds;
        calendarLeadingConstraint.constant = CGFloat(Int((screenSize.width - 342) / 2));
        calendarTrailingConstraint.constant = screenSize.width - calendarLeadingConstraint.constant - 342;

        if (indexPath.row < 7){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarHeaderCell", forIndexPath: indexPath) as! CalendarHeaderCell;
            
            switch indexPath.row {
            case 0:
                cell.dayLabel.text = "S";
            case 1:
                cell.dayLabel.text = "M";
            case 2:
                cell.dayLabel.text = "T";
            case 3:
                cell.dayLabel.text = "W";
            case 4:
                cell.dayLabel.text = "T";
            case 5:
                cell.dayLabel.text = "F";
            case 6:
                cell.dayLabel.text = "S";
            default:
                cell.dayLabel.text = "Error";
            }
            
            cell.userInteractionEnabled = false;
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = UIColor.blackColor().CGColor
            
//            print("screenSize: " + String(screenSize));
//            print("calendarLeadingConstraint: " + String(calendarLeadingConstraint.constant));
//            print("calendarTrailingConstraint: " + String(calendarTrailingConstraint.constant));
//            print(cell.bounds.width)
            
            return cell
            
        } else if (indexPath.row >= 7 && indexPath.row < 7 + spacerCellCount) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarDayCell", forIndexPath: indexPath) as! CalendarDayCell;
            cell.dayLabel.text = "";
            cell.backgroundColor = UIColor.whiteColor();
            cell.userInteractionEnabled = false;
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = UIColor.blackColor().CGColor
            cell.indicatorView.hidden = true;
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarDayCell", forIndexPath: indexPath) as! CalendarDayCell;
            
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let components = NSDateComponents()
            components.day = indexPath.row - 7 - spacerCellCount;
            cell.date = calendar.dateByAddingComponents(components, toDate: getFirstDayOfMonth(), options: [])!
            
            
            cell.dayLabel.text = String(indexPath.row - 6 - spacerCellCount);
            cell.backgroundColor = UIColor.whiteColor();
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = UIColor.blackColor().CGColor
            
            var indicatorState = false;
            for symptom in symptoms.symptoms
            {
                print("cell.date: " + String(cell.date) + ", symptom.date: " + String(symptom.date));
                if (symptom.date.sameDate(cell.date)){
                    indicatorState = true;
                    print("indicatorState true");
                }
            }
            if indicatorState {
                cell.indicatorView.hidden = false;
            } else {
                cell.indicatorView.hidden = true;
            }
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (indexPath.row < 7){
            return getHeaderCellSize()
        } else {
            return getDayCellSize();
        }
    }
    
    func getHeaderCellSize() -> CGSize {
        if (UIScreen.mainScreen().bounds.width < 350){
            return CGSize(width: 40, height: 20)
        } else {
            return CGSize(width: 50, height: 25)
        }
    }
    
    func getDayCellSize() -> CGSize {
        if (UIScreen.mainScreen().bounds.width < 350){
            return CGSize(width: 40, height: 40)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        monthLabel.text = getFirstDayOfMonth().monthYearFormat();
        self.view.backgroundColor = UIColor.visionTanColor();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
