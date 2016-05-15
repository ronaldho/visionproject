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
    @IBOutlet var calendarWidthConstraint: NSLayoutConstraint!;
    
    @IBAction func swipe(sender: AnyObject) {
        if sender.direction == .Left {
            changeCurrentMonth(1);
        } else if sender.direction == .Right {
            changeCurrentMonth(-1);
        }
    }
    
    var symptoms: Symptoms = Symptoms();
    
    var delegate: CalendarViewDelegate?;
    var currentMonth: NSDate!;
    var selectedCell: CalendarDayCell?;
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear");
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        print("didSelectItemAtIndexPath");
        let cell: CalendarDayCell = collectionView.cellForItemAtIndexPath(indexPath)! as! CalendarDayCell;
        
        if (selectedCell != nil){
            selectedCell!.backgroundColor = UIColor.whiteColor();
        }
        
        cell.backgroundColor = UIColor.visionLightGreenColor();
        selectedCell = cell;
        
        delegate!.dateChanged(cell.date);
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getNumberOfCells();
    }
    
    func getNumberOfCells() -> Int {
        let headerCellCount = 7;
        let spacerCellCount = getWeekdayOfDate(currentMonth) - 1;
        let dayCellCount = getDaysInMonth();
        return headerCellCount + spacerCellCount + dayCellCount;
    }
    
    func changeCurrentMonth(monthsToIncreaseBy: Int){
        print("changeCurrentMonth");
        let nsCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let dateComponents = NSDateComponents()
        dateComponents.month = monthsToIncreaseBy
        
        let newMonthComponent = nsCalendar.dateByAddingComponents(dateComponents, toDate: currentMonth, options: [])!
        let components = nsCalendar.components([.Year, .Month], fromDate: newMonthComponent);
        
        currentMonth = nsCalendar.dateFromComponents(components)!
        
        monthLabel.text = currentMonth.monthYearFormat();
        calendar.reloadData();
        calendar.layoutIfNeeded();
        
        
        selectAppropriateDayCell();
    }
    
    func selectAppropriateDayCell() {
        print("selectAppropriateDayCell");
        // select first day of month, or current day
        
        var indexPathToSelect: NSIndexPath?;
        var dateToSelect: NSDate?;
        
        if currentMonth.sameDate(getFirstDayOfMonth(NSDate())){
            dateToSelect = NSDate();
        } else {
            dateToSelect = currentMonth;
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
        let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: currentMonth, options: [])!
        let daysInMonth = calendar.components(.Day, fromDate: endOfMonth);
        return daysInMonth.day;

    }
    
    func getWeekdayOfDate(date: NSDate) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: date)
        return myComponents.weekday;
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cellForItemAtIndexPath")
        
        let spacerCellCount = getWeekdayOfDate(currentMonth) - 1;

        if (indexPath.row < 7){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarHeaderCell", forIndexPath: indexPath) as! CalendarHeaderCell;
            
            let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"];
            cell.dayLabel.text = daysOfWeek[indexPath.row];
            
            cell.userInteractionEnabled = false;
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = UIColor.blackColor().CGColor
            
            return cell
            
        } else if (indexPath.row >= 7 && indexPath.row < 7 + spacerCellCount) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarDayCell", forIndexPath: indexPath) as! CalendarDayCell;
            cell.dayLabel.text = "";
            cell.backgroundColor = UIColor.whiteColor();
            cell.userInteractionEnabled = false;
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = UIColor.blackColor().CGColor
            cell.indicatorView.hidden = true;
            cell.date = nil;
            cell.tag = indexPath.row;
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarDayCell", forIndexPath: indexPath) as! CalendarDayCell;
            
            let nsCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let components = NSDateComponents()
            components.day = indexPath.row - 7 - spacerCellCount;
            cell.date = nsCalendar.dateByAddingComponents(components, toDate: currentMonth, options: [])!
            
            cell.userInteractionEnabled = true;
            cell.dayLabel.text = String(indexPath.row - 6 - spacerCellCount);
            
            cell.backgroundColor = UIColor.whiteColor();
            
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = UIColor.blackColor().CGColor
            
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
            
            if (indexPath.row == getNumberOfCells() - 1){
                delegate!.setCalendarContainerHeight(calendar.contentSize.height + 60);
            }
            cell.tag = indexPath.row;
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print("sizeForItemAtIndexPath");
        if (indexPath.row < 7){
            return getHeaderCellSize()
        } else {
            return getDayCellSize();
        }
    }
    
    func getHeaderCellSize() -> CGSize {
        return CGSize(width: calendarWidthConstraint.constant/7, height: calendarWidthConstraint.constant/14)
    }
    
    func getDayCellSize() -> CGSize {
        return CGSize(width: calendarWidthConstraint.constant/7, height: calendarWidthConstraint.constant/7)
    }
    
    override func viewDidLoad() {
        print("viewDidLoad");
        super.viewDidLoad()
        
        currentMonth = getFirstDayOfMonth(NSDate());
        monthLabel.text = currentMonth.monthYearFormat();
        
        calendar.reloadData();
        calendar.layoutIfNeeded();
        selectAppropriateDayCell();
        
        self.view.backgroundColor = UIColor.visionTanColor();
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds;
        if screenSize.width < 350 {
            calendarWidthConstraint.constant = 280
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
