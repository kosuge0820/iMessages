//
//  RecentsTableViewController.swift
//  iMessagesClone
//
//  Created by 小菅仁士 on 2016/03/30.
//  Copyright © 2016年 Ryo. All rights reserved.
//

import UIKit

class RecentsTableViewController: UITableViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.logoutButton
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if User.currentUser() == nil {
            showLogin()
        }
    }
    
    private func showLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = storyboard.instantiateViewControllerWithIdentifier("WelcomeNavigationViewController") as! UINavigationController
        self.presentViewController(welcomeViewController, animated: true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    
    @IBAction func logoutButton_Clicked(sender: UIBarButtonItem) {
        User.currentUser()?.currentTeamId = ""
        User.currentUser()?.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                User.logOut()
                self.showLogin()
            } else {
                print("\(error?.localizedDescription)")
            }
        })
    }
 }
