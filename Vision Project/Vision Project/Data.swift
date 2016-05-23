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
    
    //
    // MARK: Medication
    //
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
                for i in 0...medications.count-1 {
                    let name = medications[i].valueForKey("name") as! String;
                    let imageData = medications[i].valueForKey("image") as! NSData?;
                    let croppedImageData = medications[i].valueForKey("croppedImage") as! NSData?;
                    let id = medications[i].valueForKey("id") as! String;
                    let imageUrl = medications[i].valueForKey("imageUrl") as! String?;
                    let pageUrl = medications[i].valueForKey("pageUrl") as! String?;
                    
                    var image: UIImage?;
                    var croppedImage: UIImage?;
                    
                    if (imageData != nil){
                        image = UIImage(data: imageData!);
                        croppedImage = UIImage(data: croppedImageData!);
                    }
                    
                    let temp: Medication = Medication(withName: name, andImage: image, andCroppedImage: croppedImage, andId: id, andImageUrl: imageUrl, andPageUrl: pageUrl)
                    
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
                let croppedImageData = UIImageJPEGRepresentation(med.croppedImage!, 1)
                medicationNew.setValue(croppedImageData, forKey: "croppedImage")
            } else {
                medicationNew.setNilValueForKey("image");
                medicationNew.setNilValueForKey("croppedImage");
            }

            medicationNew.setValue(id, forKey: "id")
            medicationNew.setValue(med.name, forKey: "name")
            medicationNew.setValue(med.imageUrl, forKey: "imageUrl")
            medicationNew.setValue(med.pageUrl, forKey: "pageUrl")
            
        } else {
            id = med.id
            
            let fetchRequest = NSFetchRequest(entityName: "Medication")
            fetchRequest.predicate = NSPredicate(format: "id=%@", med.id);
            
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    info[0].setValue(med.name, forKey: "name")
                    info[0].setValue(med.imageUrl, forKey: "imageUrl")
                    info[0].setValue(med.pageUrl, forKey: "pageUrl")
                    
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

    
    
    //
    // MARK: MyMedication
    //
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
                for i in 0...medications.count-1 {
                    let name = medications[i].valueForKey("name") as! String;
                    let imageData = medications[i].valueForKey("image") as! NSData?;
                    let croppedImageData = medications[i].valueForKey("croppedImage") as! NSData?;
                    let breakfast = medications[i].valueForKey("breakfast") as! Bool;
                    let lunch = medications[i].valueForKey("lunch") as! Bool;
                    let dinner = medications[i].valueForKey("dinner") as! Bool;
                    let bed = medications[i].valueForKey("bed") as! Bool;
                    let id = medications[i].valueForKey("id") as! String;
                    let instructions = medications[i].valueForKey("instructions") as! String;
                    let date = medications[i].valueForKey("date") as! NSDate;
                    let discontinued = medications[i].valueForKey("discontinued") as! Bool;
                    
                    var image: UIImage?;
                    var croppedImage: UIImage?;
                    
                    if (imageData != nil){
                        image = UIImage(data: imageData!);
                        croppedImage = UIImage(data: croppedImageData!);
                    }
                    
                    let temp: MyMedication = MyMedication(withName: name, andImage: image, andCroppedImage: croppedImage, andInstructions: instructions, andId: id, andBreakfast: breakfast, andLunch: lunch, andDinner: dinner, andBed: bed, andDate: date, andDiscontinued: discontinued);
                    
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
            
            medicationNew.setValue(id, forKey: "id")
            medicationNew.setValue(med.name, forKey: "name")
            medicationNew.setValue(med.instructions, forKey: "instructions")
            medicationNew.setValue(NSDate(), forKey: "date")
            medicationNew.setValue(med.discontinued, forKey: "discontinued")

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
                    info[0].setValue(med.instructions, forKey: "instructions")
                    info[0].setValue(med.date, forKey: "date")
                    info[0].setValue(med.discontinued, forKey: "discontinued")
                    
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
    
    
    
    
    //
    // MARK: MyMedicationHistory
    //
    static func getMyMedicationHistory(medIdToGet: String) -> [MyMedicationHistory]{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "MyMedicationHistory")
        fetchRequest.predicate = NSPredicate(format: "medId== %@", medIdToGet)
        
        var medicationHistoryArray: [MyMedicationHistory] = [MyMedicationHistory]();
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let medicationHistories = results as! [NSManagedObject]
            if (medicationHistories.count > 0){
                for i in 0...medicationHistories.count-1 {
                    let id = medicationHistories[i].valueForKey("id") as! String;
                    let medId = medicationHistories[i].valueForKey("medId") as! String;
                    let date = medicationHistories[i].valueForKey("date") as! NSDate;
                    let text = medicationHistories[i].valueForKey("text") as! String;
                    
                    let temp: MyMedicationHistory = MyMedicationHistory(withId: id, andMedId: medId, andDate: date, andText: text)
                    
                    // Insert instead of append so that latest history is at beginning of array
                    medicationHistoryArray.insert(temp, atIndex: 0);
                }
            } else {
                // No MedicationHistories in Core Data
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return medicationHistoryArray;
    }
    
    static func saveMyMedicationHistory(medHistory: MyMedicationHistory) -> String{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var id = NSUUID().UUIDString
        
        if (medHistory.id == "0"){
            let entity =  NSEntityDescription.entityForName("MyMedicationHistory",
                inManagedObjectContext:managedContext)
            
            let medicationHistoryNew = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            medicationHistoryNew.setValue(medHistory.medId, forKey: "medId")
            medicationHistoryNew.setValue(medHistory.date, forKey: "date")
            medicationHistoryNew.setValue(id, forKey: "id")
            medicationHistoryNew.setValue(medHistory.text, forKey: "text")
            
        } else {
            id = medHistory.id
            
            let fetchRequest = NSFetchRequest(entityName: "MyMedicationHistory")
            fetchRequest.predicate = NSPredicate(format: "id=%@", medHistory.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    info[0].setValue(medHistory.medId, forKey: "medId")
                    info[0].setValue(medHistory.date, forKey: "date")
                    info[0].setValue(medHistory.text, forKey: "text")
                    
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
    
    
    static func deleteMyMedicationHistory(medHistory: MyMedicationHistory){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if (medHistory.id == "0"){
            print("Error: trying to delete medicationHistory with id == 0");
            
        } else {
            let fetchRequest = NSFetchRequest(entityName: "MyMedicationHistory")
            fetchRequest.predicate = NSPredicate(format: "id=%@", medHistory.id);
            
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
    
    
    
    
    //
    // MARK: Symptoms
    //
    static func getAllSymptoms() -> [Symptom]{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Symptom")
        
        var symptomArray: [Symptom] = [Symptom]();
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let symptoms = results as! [NSManagedObject]
            if (symptoms.count > 0){
                for i in 0 ... symptoms.count-1 {
                    let id = symptoms[i].valueForKey("id") as! String;
                    let date = symptoms[i].valueForKey("date") as! NSDate;
                    let text = symptoms[i].valueForKey("text") as! String;
                    let tagIDString = symptoms[i].valueForKey("tags") as! String;
                    let imageData = symptoms[i].valueForKey("image") as! NSData?;
                    let croppedImageData = symptoms[i].valueForKey("croppedImage") as! NSData?;
                    
                    var image: UIImage?;
                    var croppedImage: UIImage?;
                    
                    if (imageData != nil){
                        image = UIImage(data: imageData!);
                        croppedImage = UIImage(data: croppedImageData!);
                    }
                    
                    let temp: Symptom = Symptom(withId: id, andDate: date, andText: text, andSymptomTags: [], andImage: image, andCroppedImage: croppedImage);
                    temp.symptomTagsFromString(tagIDString);
                    
                    symptomArray.append(temp);
                }
            } else {
                // No MedicationHistories in Core Data
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return symptomArray;
    }
    
    static func saveSymptom(symptom: Symptom) -> String{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var id = NSUUID().UUIDString
        
        if (symptom.id == "0"){
            let entity =  NSEntityDescription.entityForName("Symptom",
                inManagedObjectContext:managedContext)
            
            let symptomNew = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            if (symptom.image != nil){
                let imageData = UIImageJPEGRepresentation(symptom.image!, 1)
                symptomNew.setValue(imageData, forKey: "image")
                let croppedImageData = UIImageJPEGRepresentation(symptom.croppedImage!, 1)
                symptomNew.setValue(croppedImageData, forKey: "croppedImage")
            } else {
                symptomNew.setNilValueForKey("image");
                symptomNew.setNilValueForKey("croppedImage");
            }

            symptomNew.setValue(id, forKey: "id")
            symptomNew.setValue(symptom.date, forKey: "date")
            symptomNew.setValue(symptom.text, forKey: "text")
            symptomNew.setValue(symptom.symptomTagsToString(), forKey: "tags")
            
        } else {
            id = symptom.id
            
            let fetchRequest = NSFetchRequest(entityName: "Symptom")
            fetchRequest.predicate = NSPredicate(format: "id=%@", symptom.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    info[0].setValue(symptom.date, forKey: "date")
                    info[0].setValue(symptom.text, forKey: "text")
                    info[0].setValue(symptom.symptomTagsToString(), forKey: "tags")
                    
                    if (symptom.image != nil){
                        let imageData = UIImageJPEGRepresentation(symptom.image!, 1)
                        info[0].setValue(imageData, forKey: "image")
                        let croppedImageData = UIImageJPEGRepresentation(symptom.croppedImage!, 1)
                        info[0].setValue(croppedImageData, forKey: "croppedImage")
                    } else {
                        info[0].setNilValueForKey("image")
                        info[0].setNilValueForKey("croppedImage")
                    }
                    
                } else {
                    print("Error: trying to saveSymptom(), but more or less than 1 object was found with the id");
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
    
    
    static func deleteSymptom(symptom: Symptom){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if (symptom.id == "0"){
            print("Error: trying to delete symptom with id == 0");
            
        } else {
            let fetchRequest = NSFetchRequest(entityName: "Symptom")
            fetchRequest.predicate = NSPredicate(format: "id=%@", symptom.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    
                    managedContext.deleteObject(info[0]);
                    
                } else {
                    print("Error: trying to deleteSymptom(), but more or less than 1 object was found with the id");
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
    
    
    
    
    //
    // SymptomTag
    //
    static func getAllSymptomTags() -> [SymptomTag]{
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "SymptomTag")
        
        var symptomTagArray: [SymptomTag] = [SymptomTag]();
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            let symptomTags = results as! [NSManagedObject]
            if (symptomTags.count > 0){
                for i in 0 ... symptomTags.count-1 {
                    let id = symptomTags[i].valueForKey("id") as! String;
                    let name = symptomTags[i].valueForKey("name") as! String;
                    let colorString = symptomTags[i].valueForKey("color") as! String;
                    let enabled = symptomTags[i].valueForKey("enabled") as! Bool;

                    let temp: SymptomTag = SymptomTag(withId: id, andColor: UIColor.getColorFromString(colorString), andName: name, andEnabled: enabled);
                    
                    symptomTagArray.append(temp);
                }
            } else {
                // No MedicationHistories in Core Data
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return symptomTagArray;
    }
    
    static func saveSymptomTag(symptomTag: SymptomTag) -> String{
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var id = NSUUID().UUIDString
        
        if (symptomTag.id == "0"){
            let entity =  NSEntityDescription.entityForName("SymptomTag",
                                                            inManagedObjectContext:managedContext)
            
            let symptomTagNew = NSManagedObject(entity: entity!,
                                             insertIntoManagedObjectContext: managedContext)
            
            symptomTagNew.setValue(id, forKey: "id")
            symptomTagNew.setValue(symptomTag.name, forKey: "name")
            symptomTagNew.setValue(symptomTag.enabled, forKey: "enabled")
            symptomTagNew.setValue(symptomTag.color.getStringFromColor(), forKey: "color")
            
        } else {
            id = symptomTag.id
            
            let fetchRequest = NSFetchRequest(entityName: "SymptomTag")
            fetchRequest.predicate = NSPredicate(format: "id=%@", symptomTag.id);
            
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    info[0].setValue(symptomTag.name, forKey: "name")
                    info[0].setValue(symptomTag.enabled, forKey: "enabled")
                    info[0].setValue(symptomTag.color.getStringFromColor(), forKey: "color")
                    
                    
                    
                } else {
                    print("Error: trying to saveSymptomTag(), but more or less than 1 object was found with the id");
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
    
    
    static func deleteSymptomTag(symptomTag: SymptomTag){
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if (symptomTag.id == "0"){
            print("Error: trying to delete symptomTag with id == 0");
            
        } else {
            let fetchRequest = NSFetchRequest(entityName: "SymptomTag")
            fetchRequest.predicate = NSPredicate(format: "id=%@", symptomTag.id);
            
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    
                    managedContext.deleteObject(info[0]);
                    
                } else {
                    print("Error: trying to deleteSymptomTag(), but more or less than 1 object was found with the id");
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
