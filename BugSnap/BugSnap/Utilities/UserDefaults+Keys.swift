//
//  UserDefaults+Keys.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/24/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
    Stores the authentication keys required
*/
public extension UserDefaults {
    
    /// The keys to save the authentication keys
    enum JIRAAuthtenticationKeys : String {
        
        /// The user name for JIRA
        case userName = "com.grio.os.bugsnap.jira.userName"
        
        /// The api token
        case apiToken = "com.grio.os.bugsnap.jira.apitoken"
    }
    
    /// Stores the user name
    var jiraUserName : String? {
        get{
            return string(forKey: JIRAAuthtenticationKeys.userName.rawValue)
        }
        set(newVal){
            if newVal != nil {
                setValue(newVal!, forKey: JIRAAuthtenticationKeys.userName.rawValue)
            } else {
                removeObject(forKey: JIRAAuthtenticationKeys.userName.rawValue)
            }
        }
    }
    
    /// Stores the api token
    var jiraApiToken : String? {
        get{
            return string(forKey: JIRAAuthtenticationKeys.apiToken.rawValue)
        }
        set(newVal){
            if newVal != nil {
                setValue(newVal!, forKey: JIRAAuthtenticationKeys.apiToken.rawValue)
            } else {
                removeObject(forKey: JIRAAuthtenticationKeys.apiToken.rawValue)
            }
        }
    }
}
