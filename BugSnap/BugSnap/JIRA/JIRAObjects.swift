//
//  JIRAObjects.swift
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
        var link : String? = nil
        
        /// The id for the project
        var identifier : String? = nil
        
        /// The name for the project
        var name : String? = nil
        
        /// The url for the icon of this object
        var iconURL : URL? = nil
        
        /// The key for this object
        var key : String? = nil
        
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

// Definicion of a JIRA.Project
public extension JIRA {
    
    /**
     The representation of a project
     */
    class Project : Object {
        
        /// The keys for representing this object in a json object
        enum JSONProjectKeys : String, CaseIterable {
            
            /// the key in the json dictionary to get the array of avatar urls
            case avatars = "avatarUrls"
            
            /// the key in the json dictionary to get the category of the project
            case category = "projectCategory"
            
            /// The key in the json dictionary to get whether the project is a simplified one
            case simplified
            
            /// the key in the json dictionary to get the style of the project
            case style
        }
        
        /// The urls for the avatars
        var avatars : [String]? = nil
        
        /// Representation of a project category
        class Category : Object {
            
            /// The keys for representing this object in a json object
            enum JSONKeys : String {
                
                /// The key in the json dictionary to get the project description
                case userDescription = "description"
            }
            
            /// The description of the category
            var userDescription : String? = nil
            
            public override func load(from dictionary: [AnyHashable : Any]) {
                super.load(from: dictionary)
                userDescription = dictionary[JSONKeys.userDescription.rawValue] as? String
            }
        }
        
        /// The category of this project
        var category : Category? = nil
        
        /// Whether this project is simplified
        var simplified : Bool = false
        
        /// The style of this project
        var style : String? = nil
        
        override func load(from dictionary: [AnyHashable : Any]) {
            super.load(from: dictionary)
            JSONProjectKeys.allCases.forEach {
                switch $0 {
                case .simplified:
                    simplified = Bool(dictionary[$0.rawValue] as? String ?? "false") ?? false
                case .style:
                    style = dictionary[$0.rawValue] as? String
                case .avatars:
                    print("avatars")
                case .category:
                    if let categoryDictionary = dictionary[$0.rawValue] as? [AnyHashable:Any] {
                        category = Category()
                        category?.load(from: categoryDictionary)
                    }
                }
            }
        }
    }
}

/**
    Extension of JIRA to have issue fields
*/
public extension JIRA {
    
    /**
        Definition of an issue field. This is the metadata describing a field
    */
    class IssueField : Object {
        
        /// The keys for loading this from a JSON Object
        enum IssueFieldJSONKeys : String, CaseIterable {
            
             /// Whether is required
             case required
            
            /// Whether it has a default value
            case hasDefaultValue
            
            /// The operations that can be applied over this field
            case operations
            
            /// The schema for this field
            case schema
            
            /// The autocomplete URL if any
            case autoCompleteUrl
            
            /// The allowed values for this field
            case allowedValues
            
            //// The default value for this field
            case defaultValue
        }

        /// Whether this field is required
        var required = false
        
        /// Whether it has a default value
        var hasDefaultValue = false
        
        /// A set of operations that can be applied to this field
        var operations : Set<String>? = nil
        
        /**
         The schema for this particular user type, e.g. the type required when uploading the data in JIRA
         */
        class Schema {
            
            /// The json keys for loading this object from a JSON object
            enum IssueFieldSchemaJSONKeys : String, CaseIterable {
                
                /// The field type
                case fieldType = "type"
                
                /// The array element type if this is an array
                case arrayElementType = "items"
                
                /// The system alias for this field (guess is when it's a system type field)
                case systemAlias = "system"
                
                /// The custom namespace name
                case customTypeNamespace = "custom"
                
                /// The custom type identifier in the system
                case customTypeIdentifier = "customId"
            }
            
            /// The field type
            var fieldType : String? = nil
            
            /// The kind of items this field must have in case is of type array
            var arrayElementType : String? = nil
            
            /// The system alias (I don't know for sure)
            var systemAlias : String? = nil
            
            /// A custom type identifier
            var customTypeIdentifier : Int?
            
            /// the namespace for this custom field
            var customNamespace : String?
            
            /// Whether this is a custom schema
            var isCustom : Bool { return customNamespace != nil && customTypeIdentifier != nil}
            
            /**
                Loads the schema from a JSON dictionary
             - Parameter dictionary: The dictionary containing the data for this object
            */
            func load( from dictionary : [AnyHashable : Any] ) {
                IssueFieldSchemaJSONKeys.allCases.forEach {
                    let value = dictionary[$0.rawValue]
                    switch $0 {
                    case .fieldType:
                        fieldType = value as? String
                    case .arrayElementType:
                        arrayElementType = value as? String
                    case .systemAlias:
                        systemAlias = value as? String
                    case .customTypeNamespace:
                        customNamespace = value as? String
                    case .customTypeIdentifier:
                        customTypeIdentifier = value as? Int
                    }
                }
            }
        }
        
        /// The actual storage for the schema of this Issue Field
        var schema : Schema? = nil
        
        /// The autocomplete url for this field
        var autocompleteURL : URL? = nil
        
        /**
            The value corresponding to an issue field
        */
        class Value : Object {
            
            /// A string value for this field
            var stringValue : String? = nil
            
            /// A factory method for creating a value from an Object
            static func fromObject( source : Object? ) -> Value {
                let value = Value()
                value.name = source?.name
                value.identifier = source?.identifier
                value.iconURL = source?.iconURL
                value.link = source?.link
                return value
            }
            
        }
        
        /// The allowed values (if this field is restricted) for this issue field
        var allowedValues : [Value]? = nil
        
        /// The default value for this field if none is specified
        var defaultValue : Value? = nil
        
        /// The current value for this field
        var value : Value? = nil
        
        /// Whether this is a readonly field
        var isReadOnly : Bool {
            return allowedValues?.count ?? 0 == 1
        }
        
        /// Whether this is a selection field
        var isSelection : Bool {
            return allowedValues?.count ?? 0 > 1
        }
        
        /// Whether is using an autocomplete URL
        var isAutocomplete : Bool {
            return autocompleteURL != nil
        }
        
        // MARK: - Loading
        
        override public func load(from dictionary: [AnyHashable : Any]) {
            super.load(from: dictionary)
            IssueFieldJSONKeys.allCases.forEach {
                let value = dictionary[$0.rawValue]
                switch $0 {
                    case .required:
                        required = value as? Bool ?? false
                    case .hasDefaultValue:
                        hasDefaultValue = value as? Bool ?? false
                    case .operations:
                        loadOperations(operations: value)
                    case .schema:
                        loadSchema(schema: value)
                    case .autoCompleteUrl:
                        loadAutocompletURL(urlString: value)
                    case .allowedValues:
                        loadAllowedValues(values: value)
                    case .defaultValue:
                        loadDefaultValue(value: value)
                }
            }
        }
        
        // MARK: - Support
        
        private func loadOperations( operations array: Any? ) {
            guard let operationsArray = array as? [String],
                  operationsArray.count > 0 else { return }
            var set = Set<String>()
            operationsArray.forEach {
                set.insert($0)
            }
            operations = set
        }
        
        private func loadSchema( schema jsonDictionary: Any? ) {
            guard let dictionary = jsonDictionary as? [AnyHashable:Any],
                dictionary.count > 0 else { return }
            let newSchema = Schema()
            newSchema.load(from: dictionary)
            schema = newSchema
        }
        
        private func loadAutocompletURL( urlString : Any? ) {
            guard let string = urlString as? String else { return }
            autocompleteURL = URL(string: string)
        }
        
        private func loadAllowedValues( values : Any? ) {
            guard let array = values as? [[AnyHashable : Any]],
                    array.count > 0 else { return }
            var valuesArray = [Value]()
            array.forEach {
                let value = Value()
                value.load(from: $0)
                valuesArray.append(value)
            }
            allowedValues = valuesArray
        }
        
        private func loadDefaultValue( value : Any? ) {
            guard let dictionary = value as? [AnyHashable : Any],
                  dictionary.count > 0 else { return }
            let value = Value()
            value.load(from: dictionary)
            defaultValue = value
        }
    }
}

/**
    Extension of a JIRA.Project for loading the issue types
*/
public extension JIRA.Project {
    
    /**
        Representation of an issue type.
        An issue type in JIRA has the common properties of a JIRA.Object but also has a set of fields that may be required when creating an issue of such type
    */
    class IssueType : JIRA.Object {
        
        /// The keys for an issue type
        public enum IssueTypeJSONKeys : String, CaseIterable {
            /// The description given by the user
            case userDescription = "description"
            
            /// Whether this is a subtask
            case subtask = "subtask"
            
            /// The fields composing this kind of issues
            case fields = "fields"
        }
        
        /// The description of this type of issue
        var userDescription : String? = nil
        
        /// Whether this issue type is a subtask
        var subtask = false
        
        /// The fields this issue type will have
        var fields : [JIRA.IssueField]? = nil
        
        // MARK: - Loading
        
        override public func load(from dictionary: [AnyHashable : Any]) {
            super.load(from: dictionary)
            IssueTypeJSONKeys.allCases.forEach {
                let value = dictionary[$0.rawValue]
                switch $0 {
                    case .userDescription:
                        userDescription = value as? String
                    case .subtask:
                        subtask = value as? Bool ?? false
                    case .fields:
                        loadFields(array: value)
                }
            }
        }
        
        // MARK: - Support
        
        private func loadFields( array : Any? ) {
            guard let fieldsDictionary = array as? [AnyHashable:Any],
                    fieldsDictionary.count > 0 else { return }
            var loadedArray = [JIRA.IssueField]()
            fieldsDictionary.values.forEach {
                guard let dictionary = $0 as? [AnyHashable:Any] else { return }
                let field = JIRA.IssueField()
                field.load(from: dictionary)
                loadedArray.append(field)
            }
            fields = loadedArray
        }
    }
    
    /**
        Loads the issue types for the project
        - Parameter dictionary: the dictionary containing the information for the project and the issue types
    */
    func loadIssueTypes( dictionary : [AnyHashable:Any] ) -> [IssueType]? {
        guard dictionary.count > 0,
            let issueTypesJSONArray = dictionary["issuetypes"] as? [[AnyHashable:Any]],
            issueTypesJSONArray.count > 0  else { return nil }
        
        var issueTypesArray = [IssueType]()
        issueTypesJSONArray.forEach {
            let issueType = IssueType()
            issueType.load(from: $0)
            issueTypesArray.append(issueType)
        }
        return issueTypesArray
    }
}

/// Alias for the type of object we're trying to load
typealias JIRAObjectType = JIRA.Object.Type

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
