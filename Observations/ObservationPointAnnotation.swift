//
//  ObservationPointAnnotation.swift
//  Observations
//
//  Created by George McDonnell on 05/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit
import MapKit

class ObservationPointAnnotation: NSObject, MKAnnotation {

    var title: String?
    var coordinate: CLLocationCoordinate2D
    var observation: UObservation
    
    init(title: String?, coordinate: CLLocationCoordinate2D, observation: UObservation) {
        self.title = title
        self.coordinate = coordinate
        self.observation = observation
    }
}
