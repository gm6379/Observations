//
//  ViewController.swift
//  Observations
//
//  Created by George McDonnell on 02/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,  UITextFieldDelegate {
    
    @IBOutlet weak var signInUsernameTextField: UITextField!
    
    @IBOutlet weak var registerNameTextField: UITextField!
    @IBOutlet weak var registerUsernameTextField: UITextField!
    @IBOutlet weak var registerActivityIndicator: UIActivityIndicatorView!
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.isEqual(registerUsernameTextField) && textField.text != "") {
            registerActivityIndicator.hidden = false
            NetworkController.sharedInstance.registerWithUsername(registerUsernameTextField.text!, name: registerNameTextField.text!, success: { () -> Void in
                self.registerActivityIndicator.hidden = true
                self.openMenuWithUsername(textField.text!)
            }, failure: { () -> Void in
                self.registerActivityIndicator.hidden = true
                let registerAlert = UIAlertController(title: "Error", message: "Username already in use", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                registerAlert.addAction(okAction)
                self.presentViewController(registerAlert, animated: true, completion: nil)
            })
        } else if (textField.isEqual(registerNameTextField) && textField.text != "") {
            registerUsernameTextField.becomeFirstResponder()
        } else if (textField.isEqual(signInUsernameTextField) && textField.text != ""){
            openMenuWithUsername(textField.text!)
        }
        
        return true
    }
    
    func openMenuWithUsername(username: String) {
        let menuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        menuViewController.username = username
        self.showViewController(menuViewController, sender: self)
    }
}

