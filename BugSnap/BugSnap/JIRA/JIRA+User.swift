//
//  JIRA+User.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/// Extension for the user type
public extension JIRA {
    
    /**
     Definition of an user object. The user object has another fields required for assigning as
     a reporter in the project or an asignee.
     */
    class User : Object {
        
        /// The JSON keys for this user
        enum JIRAUserKeys : String, CaseIterable {
            
            /// The key for identifier of this object (the account Id, overwritten id which comes empty for users)
            case accountId
            
            /// The key in the json dictionary for the avatars
            case avatarUrls
            
            /// The key for the account type in  the json dictionary
            case accountType
            
            /// The key for the email address in the json dictionary
            case emailAddress
            
            /// The key for the display of this user in the json dictionary (this will overwrite name)
            case displayName
            
            /// the key for knowing whether this user is active
            case active
            
            /// The key for the timezone
            case timeZone
            
            /// The key for the locale
            case locale
        }
        
        /// The account type for this user
        var accountType : String? = nil
        
        /// The email address for this user
        var emailAddress : String? = nil
        
        /// The avatars for this user
        var avatars : [URL]? = nil
        
        /// Whether this user is active
        var active = false
        
        /// The time zone for this user
        var timezone : String? = nil
        
        /// The locale for this user
        var locale : String? = nil
        
        // MARK: - Loading the user
        
        public override func load(from dictionary: [AnyHashable : Any]) {
            super.load(from: dictionary)
            JIRAUserKeys.allCases.forEach {
                let value = dictionary[$0.rawValue]
                switch $0 {
                // Use the account id (the id doesn't come in users)
                case .accountId:
                    identifier = value as? String ?? identifier
                // Use the display name if available instead of the name
                case .displayName:
                    name = value as? String ?? name
                case .accountType:
                    accountType = value as? String
                case .emailAddress:
                    emailAddress = value as? String
                case .avatarUrls:
                    loadAvatars(avatars: value)
                case .active:
                    active = value as? Bool ?? false
                case .timeZone:
                    timezone = value as? String
                case .locale:
                    locale = value as? String
                }
            }
        }
        
        // MARK: - Support
        
        private func loadAvatars( avatars : Any? ) {
            if let avatarDictionary = avatars as? [AnyHashable:Any] {
                var array = [URL]()
                avatarDictionary.values.forEach {
                    if let urlString = $0 as? String,
                        let url = URL(string: urlString) {
                        array.append(url)
                    }
                }
                self.avatars = array
            }
        }
        
    }
}
