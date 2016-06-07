//
//  AppDelegate.swift
//  EMIT Project
//
//  Created by Andrew on 21/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drugApiUrl = NSURL(string: "http://emitcare.ca/api/v1/drugs")


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        saveDefaultSymptomTags();
        
        // Get latest Medication Data from API
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastUpdateDate = defaults.objectForKey("lastUpdateDate") as? NSDate;
        
        if lastUpdateDate == nil {
            let meds: [Medication] = Data.getAllMedications()
            for med in meds {
                Data.deleteMedication(med)
            }

            let request = NSURLRequest(URL: drugApiUrl!)
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                // Callback when response received
                
                var json: [[String: AnyObject]] = [[:]];
                do {
                    if data != nil {
                            json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [[String:AnyObject]];
                    } else {
                        print("Data nil in server call");
                    }

                } catch {
                    print(error)
                }
                
                for medication in json{
//                    print ("medication: \(medication)");
                    if let name = medication["name"] as? String {
                        if let pageUrl = medication["page"] as? String {
                            
                            if let imageUrlString = medication["image"] as? String {
                                
                                // Get image if api returns image url
                                let imageUrl = NSURL(string: imageUrlString)
                                let request = NSURLRequest(URL: imageUrl!)
                                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                                let session = NSURLSession(configuration: config)
                                
                                let imageTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                                    
                                    if let data = data where error == nil {
                                        
                                        // Save med with image if it downloads correctly
                                        let medImage = UIImage(data: data)
                                        let croppedImage = ImageUtils.cropToSquare(ImageUtils.fixOrientation(medImage!));
                                        
                                        if NSThread.currentThread().isMainThread {
                                            Data.saveMedication(Medication(withName: name, andImage: medImage!, andCroppedImage: croppedImage, andId: "0", andImageUrl: imageUrlString, andPageUrl: pageUrl));
                                        } else {
                                            dispatch_async(dispatch_get_main_queue()){
                                                Data.saveMedication(Medication(withName: name, andImage: medImage!, andCroppedImage: croppedImage, andId: "0", andImageUrl: imageUrlString, andPageUrl: pageUrl));
                                            }
                                        }
                                        
                                        
                                    } else {
                                        
                                        // Save med without image if failure downloading from image url
                                        if NSThread.currentThread().isMainThread {
                                            Data.saveMedication(Medication(withName: name, andImage: nil, andCroppedImage: nil, andId: "0", andImageUrl: imageUrlString, andPageUrl: pageUrl));
                                        } else {
                                            dispatch_async(dispatch_get_main_queue()){
                                                Data.saveMedication(Medication(withName: name, andImage: nil, andCroppedImage: nil, andId: "0", andImageUrl: imageUrlString, andPageUrl: pageUrl));
                                            }
                                        }
                                        
                                    }
                                    
                                }); // End image callback
                                
                                // Send image request
                                imageTask.resume()
                                
                            } else {
                                
                                // Save med without image if api doesn't return image url
                                if NSThread.currentThread().isMainThread {
                                    Data.saveMedication(Medication(withName: name, andImage: nil, andCroppedImage: nil, andId: "0", andImageUrl: nil, andPageUrl: pageUrl));
                                } else {
                                    dispatch_async(dispatch_get_main_queue()){
                                        Data.saveMedication(Medication(withName: name, andImage: nil, andCroppedImage: nil, andId: "0", andImageUrl: nil, andPageUrl: pageUrl));
                                    }
                                }

                            } // End if image url exists in json
                        } //End if page url exists in json
                    } // End if med name exists in json
                } // End med json loop
            }); // End med callback
            
            // Send med request
            task.resume()

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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

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
    
    func saveDefaultSymptomTags(){
        let symptomTags: [SymptomTag] = Data.getAllSymptomTags();
        
        if symptomTags.count == 0 {
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.redColor(), andName: "Pain", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.redOrangeColor(), andName: "", andEnabled: false));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.orangeColor(), andName: "Mood", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.orangeYellowColor(), andName: "", andEnabled: false));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.yellowColor(), andName: "Nausea", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.yellowGreenColor(), andName: "", andEnabled: false));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.greenColor(), andName: "Blood Pressure", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.greenBlueColor(), andName: "", andEnabled: false));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.blueColor(), andName: "Blood Sugars", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.bluePurpleColor(), andName: "", andEnabled: false));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.purpleColor(), andName: "Diarrhea", andEnabled: true));
            Data.saveSymptomTag(SymptomTag(withId: "0", andColor: UIColor.purpleRedColor(), andName: "", andEnabled: false));
            
        }
    }
}

