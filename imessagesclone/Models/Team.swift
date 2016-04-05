//
//  Team.swift
//  Teams
//
//  Created by kosuge_satoshi.
//  Copyright © 2015 kosuge_satoshi. All rights reserved.
//

import UIKit
import Parse

public class Team: PFObject, PFSubclassing {
    
    @NSManaged public var title: String!
    @NSManaged public var numberOfMembers: Int
    @NSManaged public var featheredImageFile: PFFile!
    @NSManaged public var memberIds: [String]!
    
    init(title: String, featuredImage: UIImage, newMemberId: String) {
        super.init()
        self.title = title
        self.featheredImageFile = featuredImage.createPFFile()
        self.memberIds = [newMemberId]
    }
    
    override init() {
        super.init()
    }
    
    public func addNewMemberWithId(newMemberId: String){
        if !memberIds.contains(newMemberId){
            memberIds.insert(newMemberId, atIndex: 0)
            numberOfMembers++
            self.saveInBackground()
        }
    }
    
    public func takeOutMemberWithId(memberId: String){
        if let index = memberIds.indexOf(memberId){
            memberIds.removeAtIndex(index)
            numberOfMembers--
            self.saveInBackground()
        }
    
    }
    
    
    override public class func initialize(){
        struct Static{
            static var onceToken: dispatch_once_t = 0
            
        }
        dispatch_once(&Static.onceToken){
            self.registerSubclass()
        }
    }
    
    public static func parseClassName() -> String {
        return "Team"
    }
}
