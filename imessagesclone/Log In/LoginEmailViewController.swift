//
//  LoginEmailViewController.swift
//  Teams
//
//  Created by kosuge_satoshi.
//  Copyright © 2015 kosuge_satoshi. All rights reserved.
//

import UIKit

class LoginEmailViewController: UIViewController {

    private var email: String!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.becomeFirstResponder()
    }
    
    @IBAction func nextButtonClicked(sender: UIButton) {

        email = emailTextField.text!
        performSegueWithIdentifier("ShowLoginPassword", sender: nil)
    }

    @IBAction func backButtonClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowLoginPassword" {
            let loginPasswordVC = segue.destinationViewController as! LoginPasswordViewController
            loginPasswordVC.email = email
        }
    }

}
