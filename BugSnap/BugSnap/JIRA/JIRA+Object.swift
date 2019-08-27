//
//  JIRAObject.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/18/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation


/**
    The representation of JIRA Objects
*/
public class JIRA : NSObject {
    
    /**
        Generic data for a JIRA Object
    */
    public class Object : NSObject {
        
        /// The keys for representing this object in a json object
        enum JSONKeys : String, CaseIterable {
            
            /// The key for the link in the json dictionary
            case link = "self"
            
            /// The key for the identifier in the json dictionary
            case identifier = "id"
            
            /// The icon URL for this object
            case iconURL = "iconUrl"
            
            /// The key for the name in the json dictionary
            case name
            
            /// The key for the "key" field in the json dictionary
            case key
        }
        
        /// The link for the project
        public var link : String? = nil
        
        /// The id for the project
        public var identifier : String? = nil
        
        /// The name for the project
        public var name : String? = nil
        
        /// The url for the icon of this object
        public var iconURL : URL? = nil
        
        /// The key for this object
        public var key : String? = nil
        
        /**
            Required initializer. This implementation is to precisely use templates in order to have generic calls for autocomplete
        */
        public override required init() {
            super.init()
        }
        
        /**
            Loads its data from a dictionary
            - Parameter dictionary: The dictionary possible containing the information of this object
        */
        func load( from dictionary: [AnyHashable:Any] ) {
            JSONKeys.allCases.forEach{
                let value = dictionary[$0.rawValue] as? String
                switch $0 {
                case .identifier:
                    identifier = value
                case .link:
                    link = value
                case .name:
                    name = value
                case .iconURL:
                    iconURL = URL(string: value ?? "")
                case .key:
                    key = value
                }
            }
        }
        
    }
}

/// Alias for the type of object we're trying to load
typealias JIRAObjectType = JIRA.Object.Type









