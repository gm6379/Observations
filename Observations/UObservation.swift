//
//  Observation.swift
//  Observations
//
//  Created by George McDonnell on 05/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class UObservation: NSObject {

    var title: String?
    var category: String?
    var date: String?
    var latitude: String?
    var longitude: String?
    var oDescription: String?
    var username: String?
    
    init(username: String?, title: String?, category: String?, date: String?, latitude: String?, longitude: String?, oDescription: String?) {
        self.username = username
        self.title = title
        self.category = category
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.oDescription = oDescription
    }
}
