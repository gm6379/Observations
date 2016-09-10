//
//  CoreDataController.swift
//  Observations
//
//  Created by George McDonnell on 04/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject {
    
    static let sharedInstance = CoreDataController()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func saveObservationWithUsername(username: String, title: String, category: String, latitude: String, longitude: String, date: String, description: String) {
        let context = appDelegate.managedObjectContext
        let observation = NSEntityDescription.insertNewObjectForEntityForName("Observation", inManagedObjectContext: context) as! Observation
        observation.username = username
        observation.title = title
        observation.category = category
        observation.latitude = latitude
        observation.longitude = longitude
        observation.date = date
        observation.oDescription = description
        appDelegate.saveContext()
    }
    
    func fetchObservationsWithUsername(username: String) -> [Observation] {
        let context = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Observation")
        
        let usernamePredicate = NSPredicate(format: "username matches[c] %@", username)
        request.predicate = usernamePredicate
        
        do {
            let observations = try context.executeFetchRequest(request) as! [Observation]
            return observations
        } catch {
            fatalError("Failed to fetch observations: \(error)")
        }
    }
    
    func deleteObservationsWithUsername(username: String) {
        let context = appDelegate.managedObjectContext
        let observations = fetchObservationsWithUsername(username)
        for observation in observations {
            context.deleteObject(observation)
        }
    }
}
