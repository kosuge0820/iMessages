//
//  SignupPasswordViewController.swift
//  Teams
//
//  Created by kosuge_satoshi.
//  Copyright © 2015 kosuge_satoshi. All rights reserved.
//

import UIKit

class SignupPasswordViewController: UIViewController
{
    var email: String!
    
    private var password: String!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var containerView: DesignableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func nextButtonClicked(sender: UIButton)
    {
        if passwordTextField.text!.isEmpty || passwordTextField.text!.length < 6 {
            shake()
        } else {
            password = passwordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            password = password.lowercaseString
            performSegueWithIdentifier("ShowSignupProfile", sender: nil)
        }
    }
    
    @IBAction func backButtonClicked(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func shake()
    {
        containerView.animation = "shake"
        containerView.curve = "spring"
        containerView.duration = 1.0
        containerView.animate()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSignupProfile" {
            let signupProfileVC = segue.destinationViewController as! SignupProfileViewController
            signupProfileVC.password = password
            signupProfileVC.email = email
        }
    }
    
    
}
























