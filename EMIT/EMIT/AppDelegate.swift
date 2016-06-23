//
//  AppDelegate.swift
//  EMIT Project
//
//  Created by Andrew on 21/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import CoreData

enum ImageObject {
    case Medication
    case MedicationDosage
}

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func handleLocalNotification(notification: UILocalNotification){
        if let userInfo = notification.userInfo as? [String: AnyObject] {
            let timeOfDay = TimeOfDay(rawValue: userInfo["timeOfDay"] as! Int)!
            print("handleLocalNotification: \(timeOfDay)")
            
            if let tabBar = self.window?.rootViewController as? UITabBarController {
                tabBar.selectedIndex = 0
                
                if let nav = tabBar.viewControllers![0] as? EMITNavigationViewController {
                    
                    if let mmvc = nav.viewControllers[0] as? MyMedicationsViewController {
                        let _ = mmvc.view
                        switch (timeOfDay){
                        case .Breakfast:
                            mmvc.toggleBreakfast()
                        case .Lunch:
                            mmvc.toggleLunch()
                        case .Dinner:
                            mmvc.toggleDinner()
                        case .Bed:
                            mmvc.toggleBed()
                        }
                    }
                }
            }
        }
    }
    
    func localNotificationAlert(notification: UILocalNotification){
        if let userInfo = notification.userInfo as? [String: AnyObject] {
            let timeOfDay = TimeOfDay(rawValue: userInfo["timeOfDay"] as! Int)!
            print("localNotificationAlert: \(timeOfDay)")
            
            let type = userInfo["type"] as! String
            
            if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                let alertController = UIAlertController(title: nil, message: "Time to take your \(type.lowercaseString) medications", preferredStyle: .Alert)
                
                let cancel = UIAlertAction(title: "Cancel",
                                           style: .Default,
                                           handler: nil)
                
                let openMeds = UIAlertAction(title: "Show Meds",
                                             style: .Default,
                                             handler: {(alert: UIAlertAction!) in
                                                self.handleLocalNotification(notification)})
                
                alertController.addAction(cancel)
                alertController.addAction(openMeds)
                
                topController.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        localNotificationAlert(notification)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        SymptomTags().saveDefaultSymptomTags();
        
        // Get latest Medication Data from API
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastUpdateDate = defaults.objectForKey("lastUpdateDate") as? NSDate;
        
        if lastUpdateDate == nil {
            MedicationAPI().getMedicationData(withCompletion: {() -> Void in
                // No completion handler
            });
        }
        
        if let aLaunchOptions = launchOptions { // Checking if there are any launch options.
            // Check if there are any local notification objects.
            if let notification = (aLaunchOptions as NSDictionary).objectForKey("UIApplicationLaunchOptionsLocalNotificationKey") as? UILocalNotification {
                // Handle the notification action on opening. Like updating a table or showing an alert.
                handleLocalNotification(notification)
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {

        if application.applicationIconBadgeNumber > 0 {
            application.applicationIconBadgeNumber = 0
        }
    }
    
//    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
//        // Point for handling the local notification Action. Provided alongside creating the notification.
//        if identifier == "ShowDetails" {
//            // Showing reminder details in an alertview
//            UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()
//        } else if identifier == "Snooze" {
//            // Snooze the reminder for 5 minutes
//            notification.fireDate = NSDate().dateByAddingTimeInterval(60*5)
//            UIApplication.sharedApplication().scheduleLocalNotification(notification)
//        } else if identifier == "Confirm" {
//            // Confirmed the reminder. Mark the reminder as complete maybe?
//        }
//        completionHandler()
//    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.plymouthsoftware.core_data" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("EMIT.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

