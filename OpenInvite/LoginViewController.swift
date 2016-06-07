//
//  ViewController.swift
//  OpenInvite
//
//  Created by Brendan McAleer on 5/23/16.
//  Copyright © 2016 Brendan McAleer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.center = view.center
        fbLoginButton.delegate = self
        view.addSubview(fbLoginButton)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if FIRAuth.auth()?.currentUser != nil {
            performSegueWithIdentifier("user_logged_in", sender: nil)
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            print(error.localizedDescription)
            return
        }
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            guard let user = user else {
                return
            }
            
            //            Save User First Name and Last Name
            
            var userDictionary = Dictionary<String, AnyObject>()
            
            let names = user.displayName?.componentsSeparatedByString(" ")
            userDictionary["first_name"] = names![0]
            userDictionary["last_name"] = names![1]
            
            self.ref.child("users/\(user.uid)").setValue(userDictionary, withCompletionBlock: { (error, ref) in
                
                if error == nil {
                    if FIRAuth.auth()?.currentUser != nil {
                        self.performSegueWithIdentifier("user_logged_in", sender: nil)
                    }
                }
            })
        })
        
    }
    //    Protocol Conforming
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
}

