//
//  SymptomSplitViewController.swift
//  EMIT Project
//
//  Created by Andrew on 11/05/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate {
    func setCalendarContainerHeight()
    func dateChanged(date: NSDate)
    func goToToday()
}

protocol SymptomTableDelegate {
    func editSymptom(cell: SymptomTableViewCell);
}

class SymptomSplitViewController: UIViewController, CalendarViewDelegate, SymptomTableDelegate, InputViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var calendar: SymptomCalendarViewController!;
    var symptomsTable: SymptomSplitTableViewController!;
    
    @IBOutlet var calendarContainer: UIView!;
    @IBOutlet var symptomsContainer: UIView!;
    @IBOutlet var symptomsContainerTopConstraintLayout: NSLayoutConstraint!;
    @IBOutlet var symptomsContainerTopConstraintCalendar: NSLayoutConstraint!;
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!;
    @IBOutlet var calendarButton: UIBarButtonItem!;
    
    var calendarSelectedDate: NSDate?
    var symptoms: Symptoms = Symptoms();
    var selectedDaySymptoms: Symptoms?;
    var itemSaved = false;
    var pageViewController: UIPageViewController!
    
    var currentMonth: NSDate!
    
    
    @IBAction func sendButtonPressed(){
        let ms: MailSender? = MailSender(parentVC: self);
        if ((ms?.anyMailAvailable()) != nil){
            performSegueWithIdentifier("SendSymptomPopover", sender: self);
        } else {
            let alertController = UIAlertController(title: nil, message: "No mail account found, please set up an account in iOS Mail app or Gmail", preferredStyle: .Alert)
            
            let actionOk = UIAlertAction(title: "OK",
                                         style: .Default,
                                         handler: nil)
            
            alertController.addAction(actionOk)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func newSymptom(button: UIButton){
        performSegueWithIdentifier("NewSymptom", sender: button)
    }
    
    @IBAction func flip(){
        
        if calendarContainer.hidden == true {
            calendarButton.tintColor = UIColor.whiteColor()
            calendarContainer.hidden = false;
            symptomsContainerTopConstraintLayout.priority = 400;
            
            if (calendar.selectedCell != nil){
                selectedDaySymptoms = Symptoms();
                selectedDaySymptoms = getSymptomsWithDate(calendar.selectedCell!.date)
            }
        } else {
            // Create view to get default tint color (blue)
            let view = UIView()
            calendarButton.tintColor = view.tintColor
            calendarContainer.hidden = true;
            symptomsContainerTopConstraintLayout.priority = 600;
            
            selectedDaySymptoms = nil;
        }
        
        UIView.animateWithDuration(0.3, animations:  {
            self.view.layoutIfNeeded()
        });
        
        reloadSymptoms();
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SymptomCalendarEmbed"){
            let scvc = segue.destinationViewController as! SymptomCalendarViewController;
            scvc.delegate = self;
            calendar = scvc;
            scvc.symptoms = self.symptoms;
            
        } else if (segue.identifier == "CalendarPageViewEmbed"){
            
            let pageViewController = segue.destinationViewController as! UIPageViewController;
            self.pageViewController = pageViewController;
            self.pageViewController.dataSource = self;
            self.pageViewController.delegate = self;
            
            if currentMonth == nil {
                currentMonth = NSDate.getFirstDayOfMonth(NSDate())
            }
            
            let startVC = self.calendarForMonth(currentMonth);
            self.calendar = startVC;
            startVC.firstLoad = true;
            let viewControllers: [UIViewController] = [startVC];
            
            self.pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            
        } else if (segue.identifier == "SymptomTableEmbed"){
            let sstvc = segue.destinationViewController as! SymptomSplitTableViewController;
            sstvc.delegate = self;
            symptomsTable = sstvc;
        }
        
        if (segue.identifier == "NewSymptom"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let svc: SymptomViewController = navCtrl.viewControllers[0] as! SymptomViewController;
            svc.delegate = self;
            svc.newMode = true;
            
        } else if (segue.identifier == "EditSymptom"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let svc: SymptomViewController = navCtrl.viewControllers[0] as! SymptomViewController;
            svc.symptom = (sender as! SymptomTableViewCell).symptom!;
            svc.delegate = self;
            svc.newMode = false;
            print("EditSymptom segue in SymptomSplitViewController.prepareForSeque()");
            
        } else if (segue.identifier == "SendSymptomPopover"){
            let navCtrl = segue.destinationViewController as! UINavigationController;
            let sendvc: SendViewController = navCtrl.viewControllers[0] as! SendViewController;
            sendvc.allSymptoms = self.symptomsTable.symptoms;
        }
    }
    
    
    override func viewWillAppear(animated: Bool){
        symptoms.symptoms = Data.getAllSymptoms();
        symptoms.sort();
        if (calendar != nil){
            calendar.symptoms = self.symptoms;
            calendar.calendar.reloadData();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentMonth = NSDate.getFirstDayOfMonth(NSDate())
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor.EMITDarkGreenColor();
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func calendarForMonth(month: NSDate) -> SymptomCalendarViewController {
        // Instantiate and set up Calendar
        let scvc: SymptomCalendarViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CalendarCollectionViewController") as! SymptomCalendarViewController;
        
        scvc.month = month;
        scvc.delegate = self;
        scvc.symptoms = self.symptoms;
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds;
        if screenSize.width < 350 {
            scvc.calendarWidth = 280
        }
        
        return scvc;
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
        let calendarMonth = pendingViewControllers[0] as! SymptomCalendarViewController

        // Make calendar area bigger if necessary
        let currentSize = calendar.view.bounds.height
        let newSize = calendarMonth.calendar.contentSize.height + 41;
        print("1 currentSize: \(currentSize), newSize: \(newSize)");
        if (newSize > currentSize){
            
            self.setCalendarContainerHeight(calendarMonth.calendar.contentSize.height + 41);
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        
        if completed {
            self.calendar = pageViewController.viewControllers![0] as! SymptomCalendarViewController
            let previousMonth = previousViewControllers[0] as! SymptomCalendarViewController
            
            // Make calendar smaller if necessary
            let currentSize = calendar.view.bounds.height
            let newSize = calendar.calendar.contentSize.height + 41;
            print("2 currentSize: \(currentSize), newSize: \(newSize)");
            if (newSize < currentSize){
                self.setCalendarContainerHeight(calendar.calendar.contentSize.height + 41);
            }
            
            // Get selected date of new month
            previousMonth.unselectDay()
            calendar.selectAppropriateDayCell()
            calendarSelectedDate = calendar.selectedCell?.date;
            dateChanged(calendarSelectedDate!);
        }
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let scvc = viewController as! SymptomCalendarViewController
        let month = scvc.month;

        return calendarForMonth(NSDate.getMonthFromMonth(month, monthsToIncreaseBy: -1));
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let scvc = viewController as! SymptomCalendarViewController
        let month = scvc.month;
        
        return calendarForMonth(NSDate.getMonthFromMonth(month, monthsToIncreaseBy: 1));
    }
    
    
    func reloadSymptoms(){
        if selectedDaySymptoms != nil {
            symptomsTable.symptoms = self.selectedDaySymptoms!;
        } else {
            symptomsTable.symptoms = self.symptoms;
        }
        
        symptomsTable.tableView.reloadData();
    }
    
    func getSymptomsWithDate(date: NSDate) -> Symptoms{
        let temp = Symptoms();
        temp.symptoms = Data.getAllSymptoms();
        
        if (temp.symptoms.count > 0){
            for i in (0...(temp.symptoms.count-1)).reverse() {
                if !temp.symptoms[i].date.sameDate(date){
                    temp.symptoms.removeAtIndex(i);
                }
            }
        }

        return temp;
    }
    
    func setCalendarContainerHeight(){
        setCalendarContainerHeight(calendar.calendar.contentSize.height + 41)
    }
    
    func setCalendarContainerHeight(height: CGFloat){
        self.view.layoutIfNeeded()
        print("setCalendarHeight(\(height))")
        self.calendarHeightConstraint.constant = height;
        self.view.layoutIfNeeded()
//        UIView.animateWithDuration(0.3, animations:  {
//            self.view.layoutIfNeeded()
//        });
    }
    
    func editSymptom(cell: SymptomTableViewCell){
        performSegueWithIdentifier("EditSymptom", sender: cell)
    }
    
    
    func dateChanged(date: NSDate){
        
        calendarSelectedDate = date
        
        if (selectedDaySymptoms == nil){
            selectedDaySymptoms = Symptoms();
        }
        
        selectedDaySymptoms! = getSymptomsWithDate(date);
        
        if symptomsTable != nil {
            reloadSymptoms();
        }
    }
    
    func goToToday(){
        if NSDate.getFirstDayOfMonth(NSDate()) == calendar.month {
            // Month is right, just select day cell
            self.calendar.selectAppropriateDayCell()
            
        } else {
            // Change month
            let direction: UIPageViewControllerNavigationDirection!;
            
            if NSDate().compare(calendarSelectedDate!) == NSComparisonResult.OrderedDescending {
                direction = UIPageViewControllerNavigationDirection.Forward
            } else {
                direction = UIPageViewControllerNavigationDirection.Reverse
            }
            
            self.calendar = calendarForMonth(NSDate.getFirstDayOfMonth(NSDate()))
            self.pageViewController.setViewControllers([calendar], direction: direction, animated: true, completion: nil)
            
            self.calendar.firstLoad = true;
        }
    }
}
