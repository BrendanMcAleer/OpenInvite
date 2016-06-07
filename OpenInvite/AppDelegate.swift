
//  AppDelegate.swift
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
import DualSlideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard?
    var controller: DualSlideMenuViewController?
    
    override init() {
        FIRApp.configure()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let leftView = storyboard?.instantiateViewControllerWithIdentifier("LeftMenuController") as! LeftViewController
        let mainView = storyboard?.instantiateViewControllerWithIdentifier("MainController") as! MainViewController
        let rightView = storyboard?.instantiateViewControllerWithIdentifier("RightMenuController") as! RightViewController
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 20, (mainView.view.frame.size.width), 44))
        let navigationItem = UINavigationItem()
        let menuButton = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AppDelegate.menuButtonTapped(_:)))
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(AppDelegate.addButtonTapped(_:)))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.title = "OpenInvite"
        navigationBar.items = [navigationItem]
        mainView.view.addSubview(navigationBar)
        
        controller = DualSlideMenuViewController(mainViewController: mainView, leftMenuViewController: leftView, rightMenuViewController: rightView)
        controller?.delegate = mainView
        controller!.rightSideOffset = 100
        controller!.leftSideOffset = 200
        controller!.collapseAll()
        controller!.addSwipeGestureInSide(leftView, direction: .Left)
        controller!.addSwipeGestureInSide(rightView, direction: .Right)
        leftView.controller = controller
        rightView.controller = controller
        window!.rootViewController = controller
        window!.makeKeyAndVisible()
        
        return true

    }
    
    func addButtonTapped(sender: UIBarButtonItem) {
        print("Add Button Tapped")
        controller?.toggle("left")
    }
    
    
    func menuButtonTapped(sender: UIBarButtonItem){
        controller?.toggle("right")
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        return FBSDKAppEvents.activateApp()
    }
}


