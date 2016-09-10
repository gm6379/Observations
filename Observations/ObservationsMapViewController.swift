//
//  ObservationsMapViewController.swift
//  Observations
//
//  Created by George McDonnell on 05/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit
import MapKit

class ObservationsMapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var observations: [UObservation] = [] {
        didSet {
            updateMap()
        }
    }
    
    var annotations = [MKAnnotation]()
    
    override func viewDidLoad() {
        updateMap()
    }

    func updateMap() {
        if (self.mapView != nil) {
            self.mapView.removeAnnotations(annotations)
        }
        annotations.removeAll()
        
        for observation in observations {
            let latitude = (observation.latitude! as NSString).doubleValue
            let longitude = (observation.longitude! as NSString).doubleValue
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let annotation = ObservationPointAnnotation(title: observation.title, coordinate: coordinate, observation: observation)
            annotations.append(annotation)
        }
        if (self.mapView != nil) {
            self.mapView.showAnnotations(annotations, animated: true)
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKindOfClass(ObservationPointAnnotation)) {
            let identifier = "ObservationsMapAnnotation"
        
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if (annotationView == nil) {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure);
                annotationView?.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
        
            return annotationView
        }
        
        return nil
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! ObservationPointAnnotation
        
        let observationDetailsViewController = storyboard?.instantiateViewControllerWithIdentifier("ObservationDetailsTableViewController") as! ObservationDetailsTableViewController
        observationDetailsViewController.observation = annotation.observation
        showViewController(observationDetailsViewController, sender: self)
    }
}
