//
//  User.swift
//  Teams
//
//  Created by kosuge_satoshi.
//  Copyright © 2015 kosuge_satoshi.
//

import UIKit
import Parse

public class User: PFUser {
    
    @NSManaged public var profileImageFile: PFFile!
    @NSManaged public var currentTeamId: String!
    
    init(username: String, password: String, email: String, image: UIImage) {
        super.init()

        self.profileImageFile = image.createPFFile()
        self.username = username
        self.password = password
        
    }
    
    override init() {
        super.init()
    }
    
    override public class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
        
    }
    
}






