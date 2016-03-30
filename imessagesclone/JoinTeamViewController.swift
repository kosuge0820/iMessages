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
            let query = PFQuery()
        }
    }
    private func shake(){
        containerView.animation = "shake"
        containerView.curve = "spring"
        containerView.duration = 1.0
        containerView.animate()  //animate開始
    }
}
