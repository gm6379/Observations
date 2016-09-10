//
//  MenuViewController.swift
//  Observations
//
//  Created by George McDonnell on 04/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Menu"
    }

    @IBAction func uploadSavedObservations(sender: UIButton) {
        let savedObservations = CoreDataController.sharedInstance.fetchObservationsWithUsername(username!)
        if (savedObservations.isEmpty) {
            let registerAlert = UIAlertController(title: nil, message: "No more observations to upload", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            registerAlert.addAction(okAction)
            self.presentViewController(registerAlert, animated: true, completion: nil)
        } else {
            NetworkController.sharedInstance.makeObservations(savedObservations, success: { () -> Void in
                let successAlert = UIAlertController(title: nil, message: "Uploaded successfully", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                successAlert.addAction(okAction)
                self.presentViewController(successAlert, animated: true, completion: nil)
                CoreDataController.sharedInstance.deleteObservationsWithUsername(self.username!)
                }, failure: { () -> Void in
                    let registerAlert = UIAlertController(title: "Error", message: "Username not registered", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    registerAlert.addAction(okAction)
                    self.presentViewController(registerAlert, animated: true, completion: nil)
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "MakeObservationSegue") {
            let destination = segue.destinationViewController as! MakeObservationTableViewController
            destination.username = username
        }

    }

}
