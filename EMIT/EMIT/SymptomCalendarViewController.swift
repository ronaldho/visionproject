//
//  SymptomCalendarViewController.swift
//  EMIT Project
//
//  Created by Andrew on 11/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class SymptomCalendarViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet var monthLabel: UILabel!;
    @IBOutlet var calendar: UICollectionView!;
    @IBOutlet var calendarWidthConstraint: NSLayoutConstraint!;
    
    var symptoms: Symptoms = Symptoms();
    var firstLoad: Bool?;
    var delegate: CalendarViewDelegate?;
    var month: NSDate!;
    var selectedCell: CalendarDayCell?;
    var calendarWidth: CGFloat?;
    
    @IBAction func todayButtonPressed(sender: AnyObject) {
        delegate!.goToToday()
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.firstLoad = true;        
        if (calendarWidth != nil) {
            calendarWidthConstraint.constant = calendarWidth!
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let cell: CalendarDayCell;
        if let indexCell = collectionView.cellForItemAtIndexPath(indexPath) {
            cell = indexCell as! CalendarDayCell
            if (selectedCell != nil){
                unselectDay();
            }
            
            selectedCell = cell;
            cell.backgroundColor = UIColor.EMITLightGreenColor();
            cell.dayLabel.textColor = UIColor.whiteColor();
            cell.dayLabel.font = UIFont.boldSystemFontOfSize(17.0)
            cell.indicatorView.backgroundColor = UIColor.whiteColor()
            
            delegate!.dateChanged(cell.date);
        } else {
            print("Error in didSelectItemAtIndexPath, indexPath.row: \(indexPath.row)")
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getNumberOfCells();
    }
    
    func getNumberOfCells() -> Int {
        let headerCellCount = 7;
        let spacerCellCount = getWeekdayOfDate(self.month) - 1;
        let dayCellCount = getDaysInMonth();
        return headerCellCount + spacerCellCount + dayCellCount;
    }
    
    func unselectDay() {
        if (selectedCell != nil){
            selectedCell!.backgroundColor = UIColor.whiteColor();
            selectedCell!.dayLabel.textColor = UIColor.blackColor();
            selectedCell!.dayLabel.font = UIFont.systemFontOfSize(17.0)
            selectedCell!.indicatorView.backgroundColor = UIColor.lightGrayColor()
            selectedCell = nil;
        }
    }
    
    func selectAppropriateDayCell() {
        // select first day of month, or current day
        
        var indexPathToSelect: NSIndexPath?;
        var dateToSelect: NSDate?;
        
        if self.month.sameDate(getFirstDayOfMonth(NSDate())){
            dateToSelect = NSDate();
        } else {
            dateToSelect = self.month;
        }

        for item in calendar.subviews {
            if let dayCell = item as? CalendarDayCell{
                if let cellDate = dayCell.date {
                    if cellDate.sameDate(dateToSelect!) {
                        indexPathToSelect = NSIndexPath(forRow: dayCell.tag, inSection: 0)
                    }
                }
            }
        }
        
        calendar.selectItemAtIndexPath(indexPathToSelect, animated: false, scrollPosition: UICollectionViewScrollPosition.None);
        collectionView(calendar, didSelectItemAtIndexPath: indexPathToSelect!);
        
    }
    
    func getFirstDayOfMonth(date: NSDate) -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components([.Year, .Month], fromDate: date)
        let startOfMonth = calendar.dateFromComponents(components)!
        
        return startOfMonth;
    }
    
    func getDaysInMonth() -> Int {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: self.month, options: [])!
        let daysInMonth = calendar.components(.Day, fromDate: endOfMonth);
        return daysInMonth.day;

    }
    
    func getWeekdayOfDate(date: NSDate) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: date)
        return myComponents.weekday;
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let spacerCellCount = getWeekdayOfDate(self.month) - 1;

        if (indexPath.row < 7){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarHeaderCell", forIndexPath: indexPath) as! CalendarHeaderCell;
            
            let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"];
            cell.dayLabel.text = daysOfWeek[indexPath.row];
            
            cell.userInteractionEnabled = false;
//            cell.view.layer.borderWidth = 1
//            cell.view.layer.borderColor = UIColor.blackColor().CGColor
//            
            return cell
            
        } else if (indexPath.row >= 7 && indexPath.row < 7 + spacerCellCount) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarDayCell", forIndexPath: indexPath) as! CalendarDayCell;
            cell.dayLabel.text = "";

            cell.backgroundColor = UIColor.clearColor();
            cell.userInteractionEnabled = false;
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = UIColor.clearColor().CGColor
            cell.indicatorView.hidden = true;
            cell.date = nil;
            cell.tag = indexPath.row;
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarDayCell", forIndexPath: indexPath) as! CalendarDayCell;
            
            let nsCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let components = NSDateComponents()
            components.day = indexPath.row - 7 - spacerCellCount;
            cell.date = nsCalendar.dateByAddingComponents(components, toDate: self.month, options: [])!
            
            cell.userInteractionEnabled = true;
            cell.dayLabel.text = String(indexPath.row - 6 - spacerCellCount);

            cell.tag = indexPath.row;
            cell.backgroundColor = UIColor.whiteColor();
            
//            cell.view.layer.borderWidth = 1
//            cell.view.layer.borderColor = UIColor.blackColor().CGColor
            
            var indicatorState = false;
            for symptom in symptoms.symptoms
            {
                if (symptom.date.sameDate(cell.date)){
                    indicatorState = true;
                }
            }
            if indicatorState {
                cell.indicatorView.hidden = false;
            } else {
                cell.indicatorView.hidden = true;
            }
            
            if (indexPath.row == self.getNumberOfCells()-1){
                if (firstLoad != nil && firstLoad!){
                    selectAppropriateDayCell();
                    delegate!.setCalendarContainerHeight();
                    firstLoad = false;
                }
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
        return CGSize(width: calendarWidthConstraint.constant/7, height: 20)
    }
    
    func getDayCellSize() -> CGSize {
        return CGSize(width: calendarWidthConstraint.constant/7, height: calendarWidthConstraint.constant/7)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        monthLabel.text = month.monthYearFormat();
        self.view.backgroundColor = UIColor.whiteColor();
        
        if (calendarWidth != nil) {
            calendarWidthConstraint.constant = calendarWidth!
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
