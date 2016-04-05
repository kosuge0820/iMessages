//
//  ContactsTableViewCell.swift
//  iMessagesClone
//
//  Created by 小菅仁士 on 2016/04/04.
//  Copyright © 2016年 satoshi. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var onlineIndicator: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: User! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        user.profileImageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if let data = imageData {
                if let image = UIImage(data: data) {
                    self.userProfileImage.image = image
                    self.userProfileImage.layer.cornerRadius = self.userProfileImage.layer.bounds.width / 2
                    self.userProfileImage.clipsToBounds = true
                }
            }
        }
        
        self.userNameLabel.text! = user.username!
        onlineIndicator.layer.cornerRadius = self.onlineIndicator.layer.bounds.width / 2
        self.onlineIndicator.clipsToBounds = true
        
        if user.objectId == User.currentUser()!.objectId {
            onlineIndicator?.hidden = false
        } else {
            let currentTeamId = User.currentUser()?.currentTeamId
            if user.currentTeamId != nil && user.currentTeamId == currentTeamId {
                onlineIndicator?.hidden = false
            } else {
                onlineIndicator?.hidden = true
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
