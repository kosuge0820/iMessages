//
//  CreateNewTeamViewController.swift
//  iMessagesClone
//
//  Created by 小菅仁士 on 2016/03/30.
//  Copyright © 2016年 Ryo. All rights reserved.
//

import UIKit
import Photos

class CreateNewTeamViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    @IBOutlet weak var teamFeaturedImage: UIImageView!
    @IBOutlet weak var newTeamTextField: UITextField!
    @IBOutlet weak var containerView: DesignableView!

    private var featuredImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTeamTextField.becomeFirstResponder()
        teamFeaturedImage.layer.cornerRadius = teamFeaturedImage.layer.bounds.width / 2
        teamFeaturedImage.clipsToBounds = true
    }
    
    @IBAction func pickFeaturedImage_Clicked(sender: UITapGestureRecognizer) {
        
        let authorication = PHPhotoLibrary.authorizationStatus()
        
        if authorication == .NotDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.pickFeaturedImage_Clicked(sender)
                })
            })
            return
        }
        
        if authorication == .Authorized {
            let controller = ImagePickerSheetController()
            controller.addAction(ImageAction(title: NSLocalizedString("take Photo or video", comment: "ActionTitle"), secondaryTitle: NSLocalizedString("Use this one", comment: "ActionTitle"), handler: { (_) -> () in
                    self.presentCamera()
                
                
                }, secondaryHandler: { (action, numberOfPhotos) -> () in
                    controller.getSelectedImagesWithCompletion({ (images) -> Void in
                        self.featuredImage = images[0]
                        self.teamFeaturedImage.image = self.featuredImage
                    })
            }))
            
            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "ActionTitle"), style: .Cancel, handler: nil, secondaryHandler: nil))
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    private func presentCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func backButton_Clicked(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func createButton_Clicked(sender: UIButton) {
        
    }
}
