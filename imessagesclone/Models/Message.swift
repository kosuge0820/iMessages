//
//  Message.swift
//  Teams
//
//  Created by kosuge_satoshi.
//  Copyright © 2015 kosuge_satoshi. All rights reserved.
//

import UIKit
import Parse

public class Message: PFObject, PFSubclassing {
    
    @NSManaged public var text: String!
    @NSManaged public var photoFile: PFFile!
    @NSManaged public var sender: PFUser!
    @NSManaged public var conversationId: String!
    
    init(text: String, sender: PFUser, conversationId: String) {
        super.init()
        
        self.text = text
        self.sender = sender
        self.conversationId = conversationId
    }
    
    init(photo: UIImage, sender: PFUser, conversationId: String) {
        super.init()
        
        self.photoFile = photo.createPFFile()
        self.sender = sender
        self.conversationId = conversationId
    }
    
    override public class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    public static func parseClassName() -> String {
        return "Message"
    }
}