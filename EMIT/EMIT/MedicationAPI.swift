//
//  MedicationAPI.swift
//  EMIT
//
//  Created by Andrew on 13/06/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit



class MedicationAPI: NSObject {
    
    var drugApiUrl = NSURL(string: "http://emitcare.ca/api/v1/drugs")
    
    func getMedicationData(){
        // Delete current data
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
            
            for medication in json {
                self.getMedicationFromData(medication)
            }
        });
        
        // Send med request
        task.resume()
    }
    
    func getMedicationFromData(data: [String: AnyObject]) {
        guard let name = data["name"] as? String else {
            return
        }
        guard let pageUrl = data["page"] as? String else {
            return
        }
        let imageUrl = data["image"] as? String
        
        let med = Medication(withName: name, andImage: nil, andCroppedImage: nil, andId: "0", andImageUrl: imageUrl, andPageUrl: pageUrl)
        
        dispatch_async(dispatch_get_main_queue()){
            med.id = Data.saveMedication(med)
            
            if let dosages = data["dosages"] as? [[String: AnyObject]] {
                for dosage in dosages {
                    self.getMedicationDosageFromData(med.id, data: dosage)
                }
            }
            
            if imageUrl != nil {
                self.getImageFromUrl(imageUrl!, med: med, medDosage: nil)
            }
        }
    }

    func getMedicationDosageFromData(medId: String, data: [String: AnyObject]){
        guard let dosageString = data["dosage"] as? String else {
            return
        }
        let imageUrl = data["imageUrl"] as? String
        
        let medDosage = MedicationDosage(withId: "0", andMedicationId: medId, andDosage: dosageString, andImageUrl: imageUrl, andImage: nil, andCroppedImage: nil)
        
        medDosage.id = Data.saveMedicationDosage(medDosage)
        
        if imageUrl != nil {
            self.getImageFromUrl(imageUrl!, med: nil, medDosage: medDosage)
        }
    }
    
    func getImageFromUrl(imageUrlString: String, med: Medication?, medDosage: MedicationDosage?) {
        if med != nil {
            print("getImageFromUrl for Med : \(med!.name)")
        } else if medDosage != nil {
            print("getImageFromUrl for MedDosage: \(medDosage!.dosage)")
        } else {
            print("problem in getImageFromUrl")
        }
        
        let imageUrl = NSURL(string: imageUrlString)
        let request = NSURLRequest(URL: imageUrl!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let imageTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if let data = data where error == nil {
                
                // Save med with image if it downloads correctly
                let image = UIImage(data: data)
                let croppedImage = ImageUtils.cropToSquare(ImageUtils.fixOrientation(image!));
                
                if med != nil {
                    med!.image = image
                    med!.croppedImage = croppedImage
                    dispatch_async(dispatch_get_main_queue()){
                        Data.saveMedication(med!)
                    }
                } else if medDosage != nil {
                    medDosage!.image = image
                    medDosage!.croppedImage = croppedImage
                    dispatch_async(dispatch_get_main_queue(), {
                        Data.saveMedicationDosage(medDosage!)
                    })
                }
            }
        });
        
        imageTask.resume()
    }
    
    

}
