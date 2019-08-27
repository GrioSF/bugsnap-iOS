//
//  JIRA+IssuePicker.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/13/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
 Extension of JIRA to have issue fields
*/
public extension JIRA {
    
    /**
        Definition of an issue picker result. This object allows to have the minimum information about an issue (like the key/summary) to associate attachments later or retrieve more information about it.
     */
    class IssuePicker : Object {
        
        /// The keys for loading this from a JSON Object
        enum IssuePickerJSONKeys : String, CaseIterable {
            
            /// Whether is required
            case summary = "summaryText"
        }
        
        // The summary for this issue
        public var summary : String? = nil
        
        // MARK: - Loading
        
        override public func load(from dictionary: [AnyHashable : Any]) {
            super.load(from: dictionary)
            IssuePickerJSONKeys.allCases.forEach {
                let value = dictionary[$0.rawValue]
                switch $0 {
                case .summary:
                    summary = value as? String ?? ""
                }
            }
        }
    }
}
