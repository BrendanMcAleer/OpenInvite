//
//  RightViewController.swift
//  OpenInvite
//
//  Created by Brendan McAleer on 5/26/16.
//  Copyright © 2016 Brendan McAleer. All rights reserved.
//

import UIKit
import DualSlideMenu
import Firebase
import FirebaseDatabase
import FBSDKCoreKit

class RightViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference()
    var eventsDictionary = Dictionary<String, AnyObject>()
    var controller: DualSlideMenuViewController!
    var openInvites = [String]()
    var strTime: String = ""
    var strDate: String = ""
    var currUser: String = ""
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var mainView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setValue(UIColor.blackColor(), forKey: "textColor")
        datePicker.backgroundColor = UIColor.whiteColor()
        self.rightView.layer.borderWidth = 1
        self.rightView.layer.cornerRadius = 10
        self.rightView.layer.zPosition = 2
        self.mainView.layer.zPosition = 1
        
        if let user = FIRAuth.auth()?.currentUser {
            ref.child("users/\(user.uid)").observeEventType(.Value, withBlock: { (snapshot) in
                
                guard let value = snapshot.value as? Dictionary<String, String> else {
                    print("No value"); return
                }
                
                self.currUser = "\(value["first_name"]! + " " + value["last_name"]!)"
            })
        }
        
        
    }
    @IBAction func datePickerAction(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        strDate = dateFormatter.stringFromDate(datePicker.date)
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = .ShortStyle
        strTime = timeFormatter.stringFromDate(datePicker.date)
        
        return
    }
    
    @IBAction func postButtonPressed(sender: UIButton) {
        let activity = activityTextField.text!
        let location = locationTextField.text!
        openInvites.append(activity)
        openInvites.append(location)
        openInvites.append(strDate)
        openInvites.append(strTime)
        
        eventsDictionary["activity"] = openInvites[0]
        eventsDictionary["location"] = openInvites[1]
        eventsDictionary["date"] = openInvites[2]
        eventsDictionary["time"] = openInvites[3]
        eventsDictionary["creator"] = currUser
        
        self.ref.child("events/9").setValue(eventsDictionary, withCompletionBlock: {(error, ref) in
            
            if error == nil {
                self.controller?.toggle("left")
            }
        })
    }
    
}
