//
//  AppDelegate.swift
//  BugSnap Demo App
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import UIKit
import BugSnap

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Enable the shake gesture
        UIApplication.shared.enableShakeGestureSnap()
        
        // Configure your server here
        JIRARestAPI.sharedInstance.serverURL = URL(string:"#put your jira server here")
        
        return true
    }



}

