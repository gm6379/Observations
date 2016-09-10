//
//  ObservationDetailsTableViewController.swift
//  Observations
//
//  Created by George McDonnell on 05/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class ObservationDetailsTableViewController: UITableViewController {

    var observation: UObservation?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = observation!.username
        titleLabel.text = observation!.title
        categoryLabel.text = observation!.category
        latitudeLabel.text = observation!.latitude
        longitudeLabel.text = observation!.longitude
        descriptionTextView.text = observation?.oDescription
        
    }
}
