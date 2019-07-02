//
//  JIRA+Attachment.swift
//  Model of an attachment for an issue
//  BugSnap
//
//  Created by Héctor García Peña on 6/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/// Models an attachment according the response given when an attachment is uploaded
public extension JIRA.IssueField {
    
    /// Description of an Attachment
    class Attachment : JIRA.Object {
        
        /// The keys for the remaining fields of an attachment
        enum AttachmentJSONKeys : String, CaseIterable {
            
            /// The name of the file when uploading the attachment
            case filename
            
            /// The author of the attachment
            case author
            
            /// The date time when it was created
            case creationTime = "created"
            
            /// The size of the attachment
            case size
            
            /// The mime type for the attachment
            case mimeType
            
            /// The link for the content of the attachment
            case contentLink = "content"
            
            /// The link for the thumbnail for the attachment
            case thumbnailLink = "thumbnail"
        }
        
        // MARK: - Properties
        
        /// The filename given to the attachment
        var filename : String? = nil
        
        /// The author of the attachment
        var author : JIRA.User? = nil
        
        /// The timestamp for the creation (TODO: convert to Date type)
        var timestamp : String? = nil
        
        /// The size in bytes for the attachment
        var size : Int? = nil
        
        /// The mime type for the attachment
        var mimeType : String? = nil
        
        /// The actual attachment link
        var attachmentLink : URL? = nil
        
        /// The thumbnail link
        var thumbnailLink : URL? = nil
        
        // MARK: - Override
        
        public override func load(from dictionary: [AnyHashable : Any]) {
            super.load(from: dictionary)
            AttachmentJSONKeys.allCases.forEach {
                let value = dictionary[$0.rawValue]
                
                switch $0 {
                    case .filename:
                        filename = value as? String
                    case .author:
                        buildUser(value: value)
                    case .creationTime:
                        timestamp = value as? String
                    case .size:
                        size = value as? Int
                    case .mimeType:
                        mimeType = value as? String
                    case .contentLink:
                        if let url = value as? String {
                            attachmentLink = URL(string: url)
                    }
                    case .thumbnailLink:
                        if let url = value as? String {
                            thumbnailLink = URL(string: url)
                    }
                }
            }
        }
        
        // MARK: - Support
        
        private func buildUser( value : Any? ) {
            guard let dictionary = value as? [AnyHashable:Any] else { return }
            let user = JIRA.User()
            user.load(from: dictionary)
            author = user
        }
    }
}
