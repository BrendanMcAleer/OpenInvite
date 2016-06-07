//
//  LeftViewController.swift
//  OpenInvite
//
//  Created by Brendan McAleer on 5/24/16.
//  Copyright © 2016 Brendan McAleer. All rights reserved.
//

import UIKit
import DualSlideMenu
import Firebase
import FirebaseDatabase
import FBSDKCoreKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var controller: DualSlideMenuViewController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    var menu = ["Account", "My Activities", "Post", "Friends", "Groups", "Invite Friends", " ", " ", " ", "Help", "Settings"]
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftView.layer.borderWidth = 1
        self.leftView.layer.cornerRadius = 10
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.grayColor()
        
//        Get Current User
        if let user = FIRAuth.auth()?.currentUser {
            displayNameLabel.text = user.displayName
            
            ref.child("users/\(user.uid)").observeEventType(.Value, withBlock: { (snapshot) in
                
                guard let value = snapshot.value as? Dictionary<String, String> else {
                    print("No value"); return
                }
                
            })
            
//            Profile Picture
            
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"cover"])
            
            graphRequest.startWithCompletionHandler({ (connection, result, error) in
                
                if error != nil {
                    print(error.localizedDescription)
                    return
                }
                
                let accessToken = result.valueForKey("id") as! String
                let profileImageURL = NSURL(string: "https://graph.facebook.com/\(accessToken)/picture?type=large")
                
                let pictureData = NSData(contentsOfURL: profileImageURL!)
                self.profileImageView.image = UIImage(data: pictureData!)
                let image = self.profileImageView.image
                
                let imageView = UIImageView(frame: CGRectMake(63, 58, 100, 100)); // set as you want
                imageView.layer.borderWidth = 1
                imageView.layer.masksToBounds = false
                imageView.layer.borderColor = UIColor.blackColor().CGColor
                imageView.layer.cornerRadius = imageView.frame.height/2
                imageView.clipsToBounds = true
                imageView.image = image;
                self.view.addSubview(imageView);
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            })
        }
    }
    
    func tableView(sender: UITableView, numberOfRowsInSection: Int) -> Int {
        return menu.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell")!
        
        cell.textLabel?.text = menu[indexPath.row]
        
        return cell
    }
}
