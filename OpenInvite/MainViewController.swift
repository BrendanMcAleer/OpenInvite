//
//  MainViewController.swift
//  OpenInvite
//
//  Created by Brendan McAleer on 5/24/16.
//  Copyright © 2016 Brendan McAleer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import DualSlideMenu

var events = [String]()

class inviteCell: UITableViewCell {
    
    @IBOutlet weak var inviteCellLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBAction func joinButtonPressed(sender: UIButton) {
        print("Join button pressed")
        joinButton.backgroundColor = UIColor.redColor()
        joinButton.setTitle("Joined", forState: .Normal)
    }
}


class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DualSlideMenuViewControllerDelegate {
    
    @IBOutlet weak var welcomeNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    let ref = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        super.viewDidLoad()
        
////        Loading Wheel
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.hidesWhenStopped = true
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        ref.child("events").observeEventType(.Value, withBlock: { snapshot in
            if let value = snapshot.value {
                for results in (value as? [AnyObject])!{
                    
                    events.append("\(results["creator"]!!) is \(results["activity"]!!) at \(results["location"]!!) on \(results["date"]!!) at \(results["time"]!!)")
                }
            }

            self.tableView.reloadData()
            }, withCancelBlock: { error in
                print(error.description)
        })
        
//        Get Current User
        if let user = FIRAuth.auth()?.currentUser {
            ref.child("users/\(user.uid)").observeEventType(.Value, withBlock: { (snapshot) in
                
                guard let value = snapshot.value as? Dictionary<String, String> else {
                    print("No value"); return
                }
                
                self.welcomeNameLabel.text = "Welcome, \(value["first_name"]!)"
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
//                self.profileImageView.image = UIImage(data: pictureData!)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
            })
            
            let graphRequest2 = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"friends"])
            
            graphRequest2.startWithCompletionHandler({ (connection, result, error) in
                
                if error != nil {
                    print(error.localizedDescription)
                    return
                }
                print(graphRequest2)
            }
        )}
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return events.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("inviteCell") as! inviteCell
        
        cell.inviteCellLabel!.text = events[indexPath.row]
        cell.inviteCellLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.inviteCellLabel.numberOfLines = 0

        return cell
    }

    func onSwipe() {
    }
    
    func didChangeView() {
    }
}