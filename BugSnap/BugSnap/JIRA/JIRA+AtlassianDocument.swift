//
//  JIRA+AtlassianDocument.swift
//  Simple implementation of an attlasian document for the comments in the description of an issue.
//  This implementation doesn't support all the formatting nor the control capturing the information.
//  BugSnap
//
//  Created by Héctor García Peña on 6/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
    Implementation of serialization of a simple text such as in the description into an Attlasian Document. Currently this implementation doesn't support the markup features but it can be extended to support them.
 
    For reference: https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/
*/
public extension JIRA.IssueField.Value {
    
    /// Container for the enumeration of keys building up the json describing an Attlasian Document
    struct Document {
        
        /// The version of the current structure
        static let version = 1
        
        /// The type for this object
        static let objectType = "doc"
        
        /// Keys for a json object that are used commonly in an attlasian document definition
        enum GeneralKeys : String {
            
            /// The type of object
            case type
            
            /// The contents of the document
            case contents = "content"
        }
        
         /// The keys for the json dictionary representing an attlasian document.
        enum RootKeys : String {
            
            /// The version of the document (currently 1)
            case version
        }
        
        /// The keys used in a text fragment inside an attlasian document
        enum TextKeys : String {
            
            /// The contents of this text node
            case paragraphContents = "text"
        }
        
        /// Representation of constants related to paragraphs
        public class Paragraph {
            
            /// The type for this object
            static let objectType = "paragraph"
        }
    }
    
    /**
        Tries to serialize this text component into the definition of the attlasian document. It uses the **stringValue** property of this value and currently it only separates into paragraphs.
        - Returns: A json dictionary with the structure of an attlasian document.
    */
    func serializeDocument() -> [String : Any]? {
        guard let string = stringValue else { return nil }
        
        var root = [String:Any]()
        root[Document.RootKeys.version.rawValue] = Document.version
        root[Document.GeneralKeys.type.rawValue] = Document.objectType
        
        let components = string.components(separatedBy: CharacterSet.newlines)
        var paragraphs = [[String:Any]]()
        components.forEach {
            
            // We don't support empty lines
            guard $0.count > 0 else { return }
            
            var paragraph = [String:Any]()
            paragraph[Document.GeneralKeys.type.rawValue] = Document.Paragraph.objectType
            
            var contents = [String:Any]()
            contents[Document.GeneralKeys.type.rawValue] = Document.TextKeys.paragraphContents.rawValue
            contents[Document.TextKeys.paragraphContents.rawValue] = $0
            
            paragraph[Document.GeneralKeys.contents.rawValue] = [contents]
            paragraphs.append(paragraph)
        }
        root[Document.GeneralKeys.contents.rawValue] = paragraphs
        
        return root
    }
}
