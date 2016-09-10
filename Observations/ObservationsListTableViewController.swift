//
//  ViewObservationsViewController.swift
//  Observations
//
//  Created by George McDonnell on 05/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class ObservationsListTableViewController: UITableViewController {

    var observations: [UObservation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel?.text = observations[indexPath.row].title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ObservationDetailsTableViewController") as! ObservationDetailsTableViewController
        detailViewController.observation = observations[indexPath.row]
        
        showViewController(detailViewController, sender: self)
    }
}
