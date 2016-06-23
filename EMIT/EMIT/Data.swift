//
//  Data.swift
//  EMIT Project
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
        var medicationObject: NSManagedObject?
        
        if (med.id == "0"){
            let entity =  NSEntityDescription.entityForName("Medication",
                                                            inManagedObjectContext:managedContext)
            medicationObject = NSManagedObject(entity: entity!,
                                                insertIntoManagedObjectContext: managedContext)
        } else {
            id = med.id
            
            let fetchRequest = NSFetchRequest(entityName: "Medication")
            fetchRequest.predicate = NSPredicate(format: "id=%@", med.id);
            
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    medicationObject = info[0]
                } else {
                    print("Error: trying to saveMedication(), but more or less than 1 object was found with the id");
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        if medicationObject != nil {
            if (med.image != nil){
                let imageData = UIImageJPEGRepresentation(med.image!, 1)
                medicationObject!.setValue(imageData, forKey: "image")
                let croppedImageData = UIImageJPEGRepresentation(med.croppedImage!, 1)
                medicationObject!.setValue(croppedImageData, forKey: "croppedImage")
            } else {
                medicationObject!.setNilValueForKey("image");
                medicationObject!.setNilValueForKey("croppedImage");
            }
            
            medicationObject!.setValue(id, forKey: "id")
            medicationObject!.setValue(med.name, forKey: "name")
            medicationObject!.setValue(med.imageUrl, forKey: "imageUrl")
            medicationObject!.setValue(med.pageUrl, forKey: "pageUrl")
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
    // MARK: MedicationDosage
    //
    static func getMedicationDosagesForMedication(med: Medication) -> [MedicationDosage] {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let dosageFetchRequest = NSFetchRequest(entityName: "MedicationDosage")
        dosageFetchRequest.predicate = NSPredicate(format: "medicationId=%@", med.id);
        var dosagesArray = [MedicationDosage]()
        
        do {
            let results =
                try managedContext.executeFetchRequest(dosageFetchRequest)
            let dosages = results as! [NSManagedObject]
            if (dosages.count > 0){
                for i in 0...dosages.count-1 {
                    let id = dosages[i].valueForKey("id") as! String;
                    let medId = dosages[i].valueForKey("medicationId") as! String;
                    let dosage = dosages[i].valueForKey("dosage") as! String;
                    let imageUrl = dosages[i].valueForKey("imageUrl") as! String?;
                    let imageData = dosages[i].valueForKey("image") as! NSData?;
                    let croppedImageData = dosages[i].valueForKey("croppedImage") as! NSData?;
                    
                    var image: UIImage?;
                    var croppedImage: UIImage?;
                    
                    if (imageData != nil){
                        image = UIImage(data: imageData!);
                        croppedImage = UIImage(data: croppedImageData!);
                    }
                    
                    let temp = MedicationDosage(withId: id, andMedicationId: medId, andDosage: dosage, andImageUrl: imageUrl, andImage: image, andCroppedImage: croppedImage)
                    dosagesArray.append(temp)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return dosagesArray
        
    }
    
    static func saveMedicationDosage(medDosage: MedicationDosage) -> String{
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var id = NSUUID().UUIDString
        var dosageObject: NSManagedObject?
        
        if (medDosage.id == "0"){
            let entity =  NSEntityDescription.entityForName("MedicationDosage",
                                                            inManagedObjectContext:managedContext)
            dosageObject = NSManagedObject(entity: entity!,
                                           insertIntoManagedObjectContext: managedContext)
        } else {
            id = medDosage.id
            
            let fetchRequest = NSFetchRequest(entityName: "MedicationDosage")
            fetchRequest.predicate = NSPredicate(format: "id=%@", medDosage.id);
            
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    dosageObject = info[0]
                } else {
                    print("Error: trying to saveMedicationDosage(), but more or less than 1 object was found with the id");
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        if dosageObject != nil {
            if (medDosage.image != nil){
                let imageData = UIImageJPEGRepresentation(medDosage.image!, 1)
                dosageObject!.setValue(imageData, forKey: "image")
                let croppedImageData = UIImageJPEGRepresentation(medDosage.croppedImage!, 1)
                dosageObject!.setValue(croppedImageData, forKey: "croppedImage")
            } else {
                dosageObject!.setNilValueForKey("image");
                dosageObject!.setNilValueForKey("croppedImage");
            }
            
            dosageObject!.setValue(id, forKey: "id")
            dosageObject!.setValue(medDosage.medicationId, forKey: "medicationId")
            dosageObject!.setValue(medDosage.dosage, forKey: "dosage")
            dosageObject!.setValue(medDosage.imageUrl, forKey: "imageUrl")
            
        }
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return id
    }

    static func deleteMedicationDosage(medDosage: MedicationDosage){
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if (medDosage.id == "0"){
            print("Error: trying to delete MedicationDosage with id == 0");
            
        } else {
            let fetchRequest = NSFetchRequest(entityName: "MedicationDosage")
            fetchRequest.predicate = NSPredicate(format: "id=%@", medDosage.id);
            
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    
                    managedContext.deleteObject(info[0]);
                    
                } else {
                    print("Error: trying to deleteMedicationDosage(), but more or less than 1 object was found with the id");
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
                    let startedDate = medications[i].valueForKey("startedDate") as! NSDate;
                    let discontinuedDate = medications[i].valueForKey("discontinuedDate") as! NSDate?;
                    let discontinued = medications[i].valueForKey("discontinued") as! Bool;
                    let pageUrl = medications[i].valueForKey("pageUrl") as! String?;
                    
                    var image: UIImage?;
                    var croppedImage: UIImage?;
                    
                    if (imageData != nil){
                        image = UIImage(data: imageData!);
                        croppedImage = UIImage(data: croppedImageData!);
                    }
                    
                    let temp: MyMedication = MyMedication(withName: name, andImage: image, andCroppedImage: croppedImage, andInstructions: instructions, andId: id, andBreakfast: breakfast, andLunch: lunch, andDinner: dinner, andBed: bed, andDate: date, andDiscontinued: discontinued, andStartedDate: startedDate, andDiscontinuedDate: discontinuedDate, andPageUrl: pageUrl);
                    
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
        var myMedicationObject: NSManagedObject?
        
        if (med.id == "0"){
            let entity =  NSEntityDescription.entityForName("MyMedication",
                inManagedObjectContext:managedContext)
            myMedicationObject = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
        } else {
            id = med.id
            
            let fetchRequest = NSFetchRequest(entityName: "MyMedication")
            fetchRequest.predicate = NSPredicate(format: "id=%@", med.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    myMedicationObject = info[0]
                } else {
                    print("Error: trying to saveMedication(), but more or less than 1 object was found with the id");
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        if myMedicationObject != nil {
            if (med.image != nil){
                let imageData = UIImageJPEGRepresentation(med.image!, 1)
                myMedicationObject!.setValue(imageData, forKey: "image")
                let croppedImageData = UIImageJPEGRepresentation(med.croppedImage!, 1)
                myMedicationObject!.setValue(croppedImageData, forKey: "croppedImage")
            } else {
                myMedicationObject!.setNilValueForKey("image");
                myMedicationObject!.setNilValueForKey("croppedImage");
            }
            
            myMedicationObject!.setValue(id, forKey: "id")
            myMedicationObject!.setValue(med.name, forKey: "name")
            myMedicationObject!.setValue(med.instructions, forKey: "instructions")
            myMedicationObject!.setValue(med.date, forKey: "date")
            myMedicationObject!.setValue(med.startedDate, forKey: "startedDate")
            myMedicationObject!.setValue(med.discontinued, forKey: "discontinued")
            myMedicationObject!.setValue(med.pageUrl, forKey: "pageUrl")
            
            if med.discontinuedDate != nil {
                myMedicationObject!.setValue(med.discontinuedDate, forKey: "discontinuedDate")
            } else {
                myMedicationObject!.setNilValueForKey("discontinuedDate")
            }
            
            myMedicationObject!.setValue(med.breakfast, forKey: "breakfast")
            myMedicationObject!.setValue(med.lunch, forKey: "lunch")
            myMedicationObject!.setValue(med.dinner, forKey: "dinner")
            myMedicationObject!.setValue(med.bed, forKey: "bed")

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
        var historyObject: NSManagedObject?
        
        if (medHistory.id == "0"){
            let entity =  NSEntityDescription.entityForName("MyMedicationHistory",
                inManagedObjectContext:managedContext)
            historyObject = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
        } else {
            id = medHistory.id
            
            let fetchRequest = NSFetchRequest(entityName: "MyMedicationHistory")
            fetchRequest.predicate = NSPredicate(format: "id=%@", medHistory.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    historyObject = info[0]
                    
                } else {
                    print("Error: trying to saveMedicationHistory(), but more or less than 1 object was found with the id");
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        if historyObject != nil {
            historyObject!.setValue(id, forKey: "id")
            historyObject!.setValue(medHistory.medId, forKey: "medId")
            historyObject!.setValue(medHistory.date, forKey: "date")
            historyObject!.setValue(medHistory.text, forKey: "text")
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
                    } else {
                        //
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
        var symptomObject: NSManagedObject?
        
        if (symptom.id == "0"){
            let entity =  NSEntityDescription.entityForName("Symptom",
                inManagedObjectContext:managedContext)
            symptomObject = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)

        } else {
            id = symptom.id
            let fetchRequest = NSFetchRequest(entityName: "Symptom")
            fetchRequest.predicate = NSPredicate(format: "id=%@", symptom.id);
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    symptomObject = info[0]
                } else {
                    print("Error: trying to saveSymptom(), but more or less than 1 object was found with the id");
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        if symptomObject != nil {
            if (symptom.image != nil){
                let imageData = UIImageJPEGRepresentation(symptom.image!, 1)
                symptomObject!.setValue(imageData, forKey: "image")
                let croppedImageData = UIImageJPEGRepresentation(symptom.croppedImage!, 1)
                symptomObject!.setValue(croppedImageData, forKey: "croppedImage")
            } else {
                symptomObject!.setNilValueForKey("image");
                symptomObject!.setNilValueForKey("croppedImage");
            }
            
            symptomObject!.setValue(id, forKey: "id")
            symptomObject!.setValue(symptom.date, forKey: "date")
            symptomObject!.setValue(symptom.text, forKey: "text")
            symptomObject!.setValue(symptom.symptomTagsToString(), forKey: "tags")
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
        var symptomTagObject: NSManagedObject?
        
        if (symptomTag.id == "0"){
            let entity =  NSEntityDescription.entityForName("SymptomTag",
                                                            inManagedObjectContext:managedContext)
            symptomTagObject = NSManagedObject(entity: entity!,
                                             insertIntoManagedObjectContext: managedContext)
            
        } else {
            id = symptomTag.id
            let fetchRequest = NSFetchRequest(entityName: "SymptomTag")
            fetchRequest.predicate = NSPredicate(format: "id=%@", symptomTag.id);
            
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                let info = results as! [NSManagedObject]
                if (info.count == 1){
                    symptomTagObject = info[0]
                    
                } else {
                    print("Error: trying to saveSymptomTag(), but more or less than 1 object was found with the id");
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        if symptomTagObject != nil {
            symptomTagObject!.setValue(id, forKey: "id")
            symptomTagObject!.setValue(symptomTag.name, forKey: "name")
            symptomTagObject!.setValue(symptomTag.enabled, forKey: "enabled")
            symptomTagObject!.setValue(symptomTag.color.getStringFromColor(), forKey: "color")
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
