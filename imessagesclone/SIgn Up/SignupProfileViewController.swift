//
//  SignupProfileViewController.swift
//  Teams
//
//  Created bykosuge_satoshi.
//  Copyright © 2015 kosuge_satoshi. All rights reserved.
//

import UIKit
import Photos

class SignupProfileViewController: UIViewController
{
    var email: String!
    var password: String!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var containerView: DesignableView!
    
    private var profileImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.becomeFirstResponder()
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.width / 2
        userProfileImageView.layer.masksToBounds = true
    }
    
    @IBAction func pickProfileImage(tap: UITapGestureRecognizer)
    {
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.pickProfileImage(tap)
                })
            })
            return
        }
        
        if authorization == .Authorized {
            let controller = ImagePickerSheetController()
            
            controller.addAction(ImageAction(title: NSLocalizedString("Take Photo or Video", comment: "ActionTitle"),
                secondaryTitle: NSLocalizedString("Use this one", comment: "Action Title"),
                handler: { (_) -> () in
                    
                    self.presentCamera()
                    
                }, secondaryHandler: { (action, numberOfPhotos) -> () in
                    controller.getSelectedImagesWithCompletion({ (images) -> Void in
                        self.profileImage = images[0]
                        self.userProfileImageView.image = self.profileImage
                    })
            }))
            
            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: nil, secondaryHandler: nil))
            
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func presentCamera()
    {
        // CHALLENGE: present normla image picker controller
        //              update the postImage + postImageView
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func signUpButtonClicked()
    {
        if userProfileImageView.image == nil || usernameTextField.text!.length < 3 {
            // animate
            shake()
        } else {
            let username = usernameTextField.text!
            let newUser = User(username: username, password: password, email: email, image: profileImage)
            newUser.signUpInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    self.performSegueWithIdentifier("JoinTeamViewController", sender: nil)
                } else {
                    print("\(error?.localizedDescription)")
                }
            })
        }
    }
    
    @IBAction func backButtonClicked()
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

}

extension SignupProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        self.profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.userProfileImageView.image! = self.profileImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}













