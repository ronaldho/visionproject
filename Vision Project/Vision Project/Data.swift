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
    
    static func getAllMyMedications() -> [MyMedication]{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "MyMedication")
        
        var medicationArray: [MyMedication] = [MyMedication]();
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let medications = results as! [NSManagedObject]
            if (medications.count > 0){
                for (var i = 0; i < medications.count; i++){
                    let name = medications[i].valueForKey("name") as! String;
                    let imageData = medications[i].valueForKey("image") as! NSData?;
                    let croppedImageData = medications[i].valueForKey("croppedImage") as! NSData?;
                    let breakfast = medications[i].valueForKey("breakfast") as! Bool;
                    let lunch = medications[i].valueForKey("lunch") as! Bool;
                    let dinner = medications[i].valueForKey("dinner") as! Bool;
                    let bed = medications[i].valueForKey("bed") as! Bool;
                    let info = medications[i].valueForKey("info") as! String;
                    let id = medications[i].valueForKey("id") as! String;
                    let notes = medications[i].valueForKey("notes") as! String;
                    let date = medications[i].valueForKey("date") as! NSDate;
                    
                    var image: UIImage?;
                    var croppedImage: UIImage?;
                    
                    if (imageData != nil){
                        image = UIImage(data: imageData!);
                        croppedImage = UIImage(data: croppedImageData!);
                    }
                    
                    let temp: MyMedication = MyMedication(withName: name, andImage: image, andCroppedImage: croppedImage, andInfo: info, andNotes: notes, andId: id, andBreakfast: breakfast, andLunch: lunch, andDinner: dinner, andBed: bed, andDate: date);
                    
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
    
    static func saveMyMedication(med: MyMedication) -> String{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var id = NSUUID().UUIDString
        
        if (med.id == "0"){
            let entity =  NSEntityDescription.entityForName("MyMedication",
                inManagedObjectContext:managedContext)
            
            let medicationNew = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            if (med.image != nil){
                let imageData = UIImageJPEGRepresentation(med.image!, 1)
                medicationNew.setValue(imageData, forKey: "image")
                let croppedImageData = UIImageJPEGRepresentation(med.croppedImage!, 1)
                medicationNew.setValue(croppedImageData, forKey: "croppedImage")
            } else {
                medicationNew.setNilValueForKey("image");
                medicationNew.setNilValueForKey("croppedImage");
            }
            
            medicationNew.setValue(med.name, forKey: "name")
            medicationNew.setValue(med.info, forKey: "info")
            medicationNew.setValue(id, forKey: "id")
            medicationNew.setValue(med.notes, forKey: "notes")
            medicationNew.setValue(med.breakfast, forKey: "breakfast")
            medicationNew.setValue(med.lunch, forKey: "lunch")
            medicationNew.setValue(med.dinner, forKey: "dinner")
            medicationNew.setValue(med.bed, forKey: "bed")
            
        } else {
            id = med.id
            
            let fetchRequest = NSFetchRequest(entityName: "MyMedication")
            fetchRequest.predicate = NSPredicate(format: "id=%@", med.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    info[0].setValue(med.name, forKey: "name")
                    info[0].setValue(med.info, forKey: "info")
                    info[0].setValue(med.notes, forKey: "notes")
                    info[0].setValue(med.breakfast, forKey: "breakfast")
                    info[0].setValue(med.lunch, forKey: "lunch")
                    info[0].setValue(med.dinner, forKey: "dinner")
                    info[0].setValue(med.bed, forKey: "bed")
                    
                    if (med.image != nil){
                        let imageData = UIImageJPEGRepresentation(med.image!, 1)
                        info[0].setValue(imageData, forKey: "image")
                        let croppedImageData = UIImageJPEGRepresentation(med.croppedImage!, 1)
                        info[0].setValue(croppedImageData, forKey: "croppedImage")
                    } else {
                        info[0].setNilValueForKey("image")
                        info[0].setNilValueForKey("croppedImage")
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
    
    
    static func deleteMyMedication(med: MyMedication){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if (med.id == "0"){
            print("Error: trying to delete medication with id == 0");
            
        } else {
            let fetchRequest = NSFetchRequest(entityName: "MyMedication")
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
    
    
    
    static func getAllMyMedicationHistory() -> [MyMedicationHistory]{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "MyMedicationHistory")
        
        var medicationHistoryArray: [MyMedicationHistory] = [MyMedicationHistory]();
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let medicationHistories = results as! [NSManagedObject]
            if (medicationHistories.count > 0){
                for (var i = 0; i < medicationHistories.count; i++){
                    let name = medicationHistories[i].valueForKey("name") as! String;
                    let imageData = medicationHistories[i].valueForKey("image") as! NSData?;
                    let croppedImageData = medicationHistories[i].valueForKey("croppedImage") as! NSData?;
                    let breakfast = medicationHistories[i].valueForKey("breakfast") as! Bool;
                    let lunch = medicationHistories[i].valueForKey("lunch") as! Bool;
                    let dinner = medicationHistories[i].valueForKey("dinner") as! Bool;
                    let bed = medicationHistories[i].valueForKey("bed") as! Bool;
                    let info = medicationHistories[i].valueForKey("info") as! String;
                    let id = medicationHistories[i].valueForKey("id") as! String;
                    let notes = medicationHistories[i].valueForKey("notes") as! String;
                    let date = medicationHistories[i].valueForKey("date") as! NSDate;
                    let version = medicationHistories[i].valueForKey("version") as! Int;
                    let medId = medicationHistories[i].valueForKey("medId") as! String;
                    
                    var image: UIImage?;
                    var croppedImage: UIImage?;
                    
                    if (imageData != nil){
                        image = UIImage(data: imageData!);
                        croppedImage = UIImage(data: croppedImageData!);
                    }
                    
                    let temp: MyMedicationHistory = MyMedicationHistory(withName: name, andImage: image, andCroppedImage: croppedImage, andInfo: info, andNotes: notes, andId: id, andBreakfast: breakfast, andLunch: lunch, andDinner: dinner, andBed: bed, andDate: date, andMedId: medId, andVersion: version);
                    
                    medicationHistoryArray.append(temp);
                }
            } else {
                // No MedicationHistories in Core Data
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return medicationHistoryArray;
    }
    
    static func saveMyMedicationHistory(med: MyMedicationHistory) -> String{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var id = NSUUID().UUIDString
        
        if (med.id == "0"){
            let entity =  NSEntityDescription.entityForName("MyMedicationHistory",
                inManagedObjectContext:managedContext)
            
            let medicationHistoryNew = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            if (med.image != nil){
                let imageData = UIImageJPEGRepresentation(med.image!, 1)
                medicationHistoryNew.setValue(imageData, forKey: "image")
                let croppedImageData = UIImageJPEGRepresentation(med.croppedImage!, 1)
                medicationHistoryNew.setValue(croppedImageData, forKey: "croppedImage")
            } else {
                medicationHistoryNew.setNilValueForKey("image");
                medicationHistoryNew.setNilValueForKey("croppedImage");
            }
            
            medicationHistoryNew.setValue(med.name, forKey: "name")
            medicationHistoryNew.setValue(med.info, forKey: "info")
            medicationHistoryNew.setValue(id, forKey: "id")
            medicationHistoryNew.setValue(med.notes, forKey: "notes")
            medicationHistoryNew.setValue(med.breakfast, forKey: "breakfast")
            medicationHistoryNew.setValue(med.lunch, forKey: "lunch")
            medicationHistoryNew.setValue(med.dinner, forKey: "dinner")
            medicationHistoryNew.setValue(med.bed, forKey: "bed")
            
        } else {
            id = med.id
            
            let fetchRequest = NSFetchRequest(entityName: "MyMedicationHistory")
            fetchRequest.predicate = NSPredicate(format: "id=%@", med.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    info[0].setValue(med.name, forKey: "name")
                    info[0].setValue(med.info, forKey: "info")
                    info[0].setValue(med.notes, forKey: "notes")
                    info[0].setValue(med.breakfast, forKey: "breakfast")
                    info[0].setValue(med.lunch, forKey: "lunch")
                    info[0].setValue(med.dinner, forKey: "dinner")
                    info[0].setValue(med.bed, forKey: "bed")
                    
                    if (med.image != nil){
                        let imageData = UIImageJPEGRepresentation(med.image!, 1)
                        info[0].setValue(imageData, forKey: "image")
                        let croppedImageData = UIImageJPEGRepresentation(med.croppedImage!, 1)
                        info[0].setValue(croppedImageData, forKey: "croppedImage")
                    } else {
                        info[0].setNilValueForKey("image")
                        info[0].setNilValueForKey("croppedImage")
                    }
                    
                    
                } else {
                    print("Error: trying to saveMedicationHistory(), but more or less than 1 object was found with the id");
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
    
    
    static func deleteMyMedicationHistory(med: MyMedicationHistory){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if (med.id == "0"){
            print("Error: trying to delete medicationHistory with id == 0");
            
        } else {
            let fetchRequest = NSFetchRequest(entityName: "MyMedicationHistory")
            fetchRequest.predicate = NSPredicate(format: "id=%@", med.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    
                    managedContext.deleteObject(info[0]);
                    
                } else {
                    print("Error: trying to deleteMedicationHistory(), but more or less than 1 object was found with the id");
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
