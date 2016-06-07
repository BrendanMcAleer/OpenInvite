//
//  FriendsViewController.swift
//  OpenInvite
//
//  Created by Brendan McAleer on 5/29/16.
//  Copyright © 2016 Brendan McAleer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import DualSlideMenu

class friendCell: UITableViewCell {
    
}

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friends = [String]()
    let ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"friends"])
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) in
            
            if error != nil {
                print(error.localizedDescription)
                return
            }
           print("In here now***************************")
        }
    )}
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! friendCell
        
//        cell.inviteCellLabel!.text = friends[indexPath.row]
//        cell.inviteCellLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        cell.inviteCellLabel.numberOfLines = 0
        
        return cell
    }
}


