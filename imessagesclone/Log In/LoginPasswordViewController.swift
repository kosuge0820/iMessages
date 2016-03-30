//
//  LoginPasswordViewController.swift
//  Teams
//
//  Created by kosuge_satoshi.
//  Copyright © 2015 kosuge_satoshi. All rights reserved.
//
import UIKit
import Parse

class LoginPasswordViewController: UIViewController {
    
    var email: String!
    private var password: String!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        passwordTextField.becomeFirstResponder()
    }
    
    
    @IBAction func logInClicked(sender: UIButton) {
        password = passwordTextField.text!
        
        
        PFUser.logInWithUsernameInBackground(email, password: password) { (user, error) -> Void in
            if error == nil {
                self.performSegueWithIdentifier("JoinTeamViewController", sender: self)
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
