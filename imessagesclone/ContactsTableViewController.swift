//
//  ContactsTableViewController.swift
//  iMessagesClone
//
//  Created by 小菅仁士 on 2016/03/30.
//  Copyright © 2016年 Ryo. All rights reserved.
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
        return cell
    }
}
