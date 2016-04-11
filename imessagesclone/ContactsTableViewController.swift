//
//  ContactsTableViewController.swift
//  iMessagesClone
//
//  Created by 小菅仁士 on 2016/03/30.
//  Copyright © 2016年 satoshi. All rights reserved.
//

import UIKit
import Parse

class ContactsTableViewController: UITableViewController {

    var teamId: String!
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Contacts"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if teamId == nil {
            teamId = User.currentUser()?.currentTeamId!
        }
        
        fetchUsers()
        
    }
    
    private func fetchUsers() {
        let teamQuery = PFQuery(className: Team.parseClassName())
        teamQuery.cachePolicy = .NetworkElseCache
        
        teamQuery.getObjectInBackgroundWithId(teamId) { (objects, error) -> Void in
            if error == nil {
                if let team = objects as? Team {
                    if let memberIds = team.memberIds {
                        let query = User.query()!
                        
                        query.whereKey("objectId", containedIn: memberIds)
                        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            if error == nil {
                                if let objects = objects as [PFObject]! {
                                    self.users.removeAll()
                                    
                                    for objects in objects {
                                        let user = objects as! User
                                        self.users.append(user)
                                    }
                                    self.tableView.reloadData()
                                }
                                
                            }
                        })
                    }
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
        
    }
    
struct StoryBoard {
    static var cellIdentifier = "Contacts Cell"
}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.cellIdentifier, forIndexPath: indexPath) as! ContactsTableViewCell
        cell.user = users[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentUser = User.currentUser()!
        let user1 = currentUser
        let user2 = self.users[indexPath.row]
        
        var conversation = Conversation(teamId: teamId, user1: user1, user2: user2)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let messageVC = storyBoard.instantiateViewControllerWithIdentifier("MessageViewController") as! MessagesViewController
        
        let predicate = NSPredicate(format: "user1 = %@ AND user2 = %@ OR user1 = @% AND user2 = @%", user1, user2, user2, user1)
        
        
        let conversationQuery = PFQuery(className: Conversation.parseClassName(), predicate: predicate)
        conversationQuery.cachePolicy = .NetworkElseCache
        conversationQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil && objects!.count > 0{
                conversation = objects?.last as! Conversation
                messageVC.conversation = conversation
                messageVC.incomingUser = user2
                messageVC.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(messageVC, animated: true)
            } else {
                conversation.saveInBackgroundWithBlock({ (success, error) -> Void in
                    messageVC.conversation = conversation
                    messageVC.incomingUser = user2
                    messageVC.hidesBottomBarWhenPushed = true
                })
                
            }
        }
        
    }
}
