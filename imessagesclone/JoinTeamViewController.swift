//
//  JoinTeamViewController.swift
//  iMessagesClone
//
//  Created by 小菅仁士 on 2016/03/30.
//  Copyright © 2016年 Ryo. All rights reserved.
//

import UIKit
import Parse
class JoinTeamViewController: UIViewController {

    @IBOutlet weak var containerView: DesignableView!
    @IBOutlet weak var teamIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamIdTextField.becomeFirstResponder() //開いた直後にテキストを入力できる状態
        
    }
    
    @IBAction func joinButton_Clicked(sender: UIButton) {
        if teamIdTextField.text!.isEmpty {
            shake()
        } else {
            let query = PFQuery(className: Team.parseClassName())
            query.whereKey("title", equalTo: teamIdTextField.text!)
            query.cachePolicy = .NetworkOnly
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    if let objects = objects as [PFObject]! {
                        if objects.count > 0 {
                            if let team = objects.first as? Team{
                                team.addNewMemberWithId((User.currentUser()?.objectId)!)
                                User.currentUser()!.currentTeamId = team.objectId!
                                User.currentUser()?.saveInBackground()
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        } else {
                            //チームがない状態
                            self.shake()
                        }
                    }
                } else {
                    print("\(error?.localizedDescription)")
                }
            })
        }
    }
     private func shake(){
        containerView.animation = "shake"
        containerView.curve = "spring"
        containerView.duration = 1.0
        containerView.animate()  //animate開始
    }
}
