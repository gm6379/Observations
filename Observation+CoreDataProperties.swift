//
//  Observation+CoreDataProperties.swift
//  Observations
//
//  Created by George McDonnell on 04/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.

import Foundation
import CoreData

extension Observation {

    @NSManaged var title: String?
    @NSManaged var category: String?
    @NSManaged var date: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var oDescription: String?
    @NSManaged var username: String?

}
