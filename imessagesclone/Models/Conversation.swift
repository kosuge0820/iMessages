//
//  Conversation.swift
//  Teams
//
//  Created by kosuge_satoshi
//  Copyright © 2015 kosuge_satoshi. All rights reserved.
//

import UIKit
import Parse

public class Conversation: PFObject, PFSubclassing {

    @NSManaged public var teamId: String!
    @NSManaged public var user1: PFUser!
    @NSManaged public var user2: PFUser!
    @NSManaged public var lastUpdate: NSDate
    
    init(teamId: String, user1: PFUser, user2: PFUser) {
        super.init()
        
        self.teamId = teamId
        self.user1 = user1
        self.user2 = user2
        self.lastUpdate = NSDate()
    }
    
    override init() {
        super.init()
    }
    
    override public class func initialize(){
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
                self.registerSubclass()
        }
    }
    
    public static func parseClassName() -> String {
        return "Conversation"
    }
}