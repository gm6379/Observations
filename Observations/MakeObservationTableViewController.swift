//
//  MakeObservationViewController.swift
//  Observations
//
//  Created by George McDonnell on 02/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class MakeObservationTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var username: String?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var uploadObservationButton: UIButton!
    
    
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var observationActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        datePicker.maximumDate = NSDate()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.text != "") {
            switch textField {
            case titleTextField: categoryTextField.becomeFirstResponder()
            case categoryTextField: latitudeTextField.becomeFirstResponder()
            case latitudeTextField: longitudeTextField.becomeFirstResponder()
            case longitudeTextField: descriptionTextView.becomeFirstResponder()
            default: break
            }
        }
        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Enter a description here..."
        }
    }
    
    @IBAction func saveObservation(sender: UIButton) {
        var obsDescription = ""
        if (descriptionTextView.text != "Enter a description here...") {
            obsDescription = descriptionTextView.text!
        }
        
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        
        CoreDataController.sharedInstance.saveObservationWithUsername(username!, title: titleTextField.text!, category: categoryTextField.text!, latitude: latitudeTextField.text!, longitude: longitudeTextField.text!, date: dateString, description: obsDescription)
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func uploadObservation(sender: UIButton) {
        uploadObservationButton.hidden = true
        observationActivityIndicator.hidden = false
        let networkController = NetworkController.sharedInstance
        
        var obsDescription = ""
        if (descriptionTextView.text != "Enter a description here...") {
            obsDescription = descriptionTextView.text!
        }
        
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        
        networkController.makeObservationWithUsername(username!, title: titleTextField.text!, category: categoryTextField.text!, latitude: latitudeTextField.text!, longitude: longitudeTextField.text!, date: dateString, description: obsDescription,
            success: { () -> Void in
                self.observationActivityIndicator.hidden = true
                self.navigationController?.popViewControllerAnimated(true)
            }) { () -> Void in
                self.observationActivityIndicator.hidden = true
                self.uploadObservationButton.hidden = false
                let registerAlert = UIAlertController(title: "Error", message: "Username not registered", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                registerAlert.addAction(okAction)
                self.presentViewController(registerAlert, animated: true, completion: nil)
        }
    }
    
}
