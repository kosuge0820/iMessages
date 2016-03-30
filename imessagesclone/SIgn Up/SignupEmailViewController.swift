//
//  SignupEmailViewController.swift
//  Teams
//
//  Created by kosuge_satoshi.
//  Copyright © 2015 kosuge_satoshi. All rights reserved.
//

import UIKit

class SignupEmailViewController: UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var containerView: DesignableView!

    private var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.becomeFirstResponder()
    }
    
    @IBAction func nextButtonClicked(sender: UIButton)
    {
        if emailTextField.text!.isEmpty || emailTextField.text!.length < 6 {
            shake()
        } else {
            email = emailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            email = email.lowercaseString
            performSegueWithIdentifier("ShowSignupPassword", sender: nil)
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
        if segue.identifier == "ShowSignupPassword" {
            let signupPasswordVC = segue.destinationViewController as! SignupPasswordViewController
            signupPasswordVC.email = email
        }
    }

}

























