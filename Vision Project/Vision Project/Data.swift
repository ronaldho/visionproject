//
//  Data.swift
//  Vision Project
//
//  Created by Andrew on 21/04/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Data: NSObject {
    
    static func getAllMedications() -> [Medication]{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Medication")
        
        var medicationArray: [Medication] = [Medication]();
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let medications = results as! [NSManagedObject]
            if (medications.count > 0){
                for (var i = 0; i < medications.count; i++){
                    let type = medications[i].valueForKey("type") as! String;
                    let date = medications[i].valueForKey("dateTime") as! NSDate;
                    let location = medications[i].valueForKey("location") as! String;
                    let careProvider = medications[i].valueForKey("careProvider") as! String;
                    let notes = medications[i].valueForKey("notes") as! String;
                    let id = medications[i].valueForKey("id") as! String;
                    let imageData = medications[i].valueForKey("image") as! NSData?;
                    let croppedPhotoData = medications[i].valueForKey("croppedPhoto") as! NSData?;
                    
                    var image: UIImage?;
                    var croppedPhoto: UIImage?;
                    
                    if (imageData != nil){
                        image = UIImage(data: imageData!);
                        croppedPhoto = UIImage(data: croppedPhotoData!);
                    }
                    
                    let temp: Medication = Medication(withType: type, andDate: date, andLocation: location, andCareProvider: careProvider, andNotes: notes, andPhoto: image, andCroppedPhoto: croppedPhoto, andId: id);
                    
                    medicationArray.append(temp);
                }
            } else {
                // No Medications in Core Data
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return medicationArray;
    }
    
    static func saveMedication(med: Medication) -> String{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var id = NSUUID().UUIDString
        
        if (med.id == "0"){
            let entity =  NSEntityDescription.entityForName("Medication",
                inManagedObjectContext:managedContext)
            
            let medicationNew = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            if (med.image != nil){
                let imageData = UIImageJPEGRepresentation(med.image!, 1)
                medicationNew.setValue(imageData, forKey: "image")
                let croppedPhotoData = UIImageJPEGRepresentation(med.croppedPhoto!, 1)
                medicationNew.setValue(croppedPhotoData, forKey: "croppedPhoto")
            } else {
                medicationNew.setNilValueForKey("image");
                medicationNew.setNilValueForKey("croppedPhoto");
            }
            
            medicationNew.setValue(med.type, forKey: "type")
            medicationNew.setValue(med.date, forKey: "dateTime")
            medicationNew.setValue(med.location, forKey: "location")
            medicationNew.setValue(med.careProvider, forKey: "careProvider")
            medicationNew.setValue(med.notes, forKey: "notes")
            medicationNew.setValue(id, forKey: "id")
            
        } else {
            id = med.id
            
            let fetchRequest = NSFetchRequest(entityName: "Medication")
            fetchRequest.predicate = NSPredicate(format: "id=%@", med.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    info[0].setValue(med.type, forKey: "type")
                    info[0].setValue(med.date, forKey: "dateTime")
                    info[0].setValue(med.location, forKey: "location")
                    info[0].setValue(med.careProvider, forKey: "careProvider")
                    info[0].setValue(med.notes, forKey: "notes")
                    
                    if (med.image != nil){
                        let imageData = UIImageJPEGRepresentation(med.image!, 1)
                        info[0].setValue(imageData, forKey: "image")
                        let croppedPhotoData = UIImageJPEGRepresentation(med.croppedPhoto!, 1)
                        info[0].setValue(croppedPhotoData, forKey: "croppedPhoto")
                    } else {
                        info[0].setNilValueForKey("image")
                        info[0].setNilValueForKey("croppedPhoto")
                    }
                    
                    
                } else {
                    print("Error: trying to saveMedication(), but more or less than 1 object was found with the id");
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return id
    }
    
    
    static func deleteMedication(med: Medication){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if (med.id == "0"){
            print("Error: trying to delete medication with id == 0");
            
        } else {
            let fetchRequest = NSFetchRequest(entityName: "Medication")
            fetchRequest.predicate = NSPredicate(format: "id=%@", med.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    
                    managedContext.deleteObject(info[0]);
                    
                } else {
                    print("Error: trying to deleteMedication(), but more or less than 1 object was found with the id");
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
