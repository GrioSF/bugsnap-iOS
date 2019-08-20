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
        
        // Configure your server here. You can use this method or the Info.plist. It's important to be sure to configure the url before attempting to communicate to JIRA.
        //JIRARestAPI.sharedInstance.serverURL = URL(string:"#put your jira server here")
        
        // Optionally provided your credentials here. You can use this method, the info.plist or manually entering your credentials at runtime
        //JIRARestAPI.sharedInstance.setupConnection(userName: "#put your jira email for authentication", apiToken: "put your api token key here")
        
        /// Try to load the credentials from the Info.plist. The following are the required keys:
        /// JIRA.URL  = '#Your JIRA server'
        /// JIRA.User = '#Your JIRA email for authentication'
        /// JIRA.APIKey = '#Your JIRA API Token key'
        /// JIRA.Project = '#Either the key, identifier or complete name for your JIRA.Project (optional)'
        
        
        UIApplication.shared.redirectLogging()
        NSLog("This statement should be on a file!")
        
        do {
            try JIRARestAPI.sharedInstance.loadConnectionParameters()
        }
        catch{
            NSLog("Error while configuring JIRA connection \(error)")
        }
        
        return true
    }



}

