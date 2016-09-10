//
//  ViewObservationsViewController.swift
//  Observations
//
//  Created by George McDonnell on 05/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class ViewObservationsViewController: UIViewController {
    
    var listViewController: ObservationsListTableViewController?
    var mapViewController: ObservationsMapViewController?
    var observations: [UObservation]? {
        didSet {
            listViewController!.observations = self.observations!
            mapViewController!.observations = self.observations!
        }
    }
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let formatter = NSDateFormatter()
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.maximumDate = NSDate()

        listViewController = storyboard?.instantiateViewControllerWithIdentifier("ObservationsListTableViewController") as? ObservationsListTableViewController
        mapViewController = storyboard?.instantiateViewControllerWithIdentifier("ObservationsMapViewController") as? ObservationsMapViewController
        
        activeViewController = listViewController
        
        NetworkController.sharedInstance.fetchAllObservations { (observations) -> (Void) in
            if (!observations.isEmpty) {
                self.observations = observations
            }
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inactiveVC = inactiveViewController {
            inactiveVC.willMoveToParentViewController(nil)
            inactiveVC.view.removeFromSuperview()
            inactiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            addChildViewController(activeVC)
            activeVC.view.frame = container.bounds
            container.addSubview(activeVC.view)
            activeVC.didMoveToParentViewController(self)
        }
    }
    
    @IBAction func toggleViewActiveViewController(sender: UIBarButtonItem) {
        if (activeViewController!.isKindOfClass(ObservationsListTableViewController)) {
            activeViewController = mapViewController
            sender.title = "List"
        } else {
            activeViewController = listViewController
            sender.title = "Map"
        }
    }
    
    @IBAction func filterByDate(sender: UIButton) {
        formatter.dateFormat = "yyyyMMdd'T'HHmm'00'"
        let dateString = formatter.stringFromDate(datePicker.date)
        NetworkController.sharedInstance.fetchObservationsWithDate(dateString) { (observations) -> (Void) in
            self.observations = observations
            UIView.animateWithDuration(0.5) { () -> Void in
                self.backgroundView.alpha = 0
                self.datePickerView.alpha = 0
            }
        }
    }
    
    @IBAction func cancelDateFilter(sender: UIButton) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.backgroundView.alpha = 0
            self.datePickerView.alpha = 0
        }
    }
    
    @IBAction func filterObservations(sender: UIBarButtonItem) {
        let sheet = UIAlertController(title: "Apply Filter", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let filterByUserAction = UIAlertAction(title: "Filter by User", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.applyFilterWithIdentifier("Filter by User")
        }
        sheet.addAction(filterByUserAction)

        let filterByDateAction = UIAlertAction(title: "Filter by Date", style: UIAlertActionStyle.Default) { (action) -> Void in
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.backgroundView.alpha = 0.5
                self.datePickerView.alpha = 1
            })
        }
        sheet.addAction(filterByDateAction)
        let filterByCategoryAction = UIAlertAction(title: "Filter by Category", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.applyFilterWithIdentifier("Filter by Category")
        }
        sheet.addAction(filterByCategoryAction)
        let unfilterAction = UIAlertAction(title: "Remove Filter", style: UIAlertActionStyle.Default) { (action) -> Void in
            NetworkController.sharedInstance.fetchAllObservations({ (observations) -> (Void) in
                self.observations = observations
            })
        }
        sheet.addAction(unfilterAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        sheet.addAction(cancelAction)
        
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    func applyFilterWithIdentifier(identifier: String) {
        let alert = UIAlertController(title: identifier, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        var handler: ((UIAlertAction) -> Void)?
        switch (identifier) {
            case "Filter by User":
                alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
                    textField.placeholder = "Username"
                }
                handler = { (action) -> Void in
                    NetworkController.sharedInstance.fetchObservationsWithUsername((alert.textFields?.first?.text)!, completionHandler: { (observations) -> (Void) in
                        self.observations = observations
                    })
                }
            case "Filter by Category":
                alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
                    textField.placeholder = "Category"
                }
                handler = { (action) -> Void in
                    NetworkController.sharedInstance.fetchObservationsWithCategory((alert.textFields?.first?.text)!, completionHandler: { (observations) -> (Void) in
                        self.observations = observations
                    })
                }
        default: break
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let filterAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default, handler: handler)
        alert.addAction(filterAction)
       
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
