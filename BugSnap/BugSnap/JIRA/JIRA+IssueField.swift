//
//  JIRA+IssueField.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
 Extension of JIRA to have issue fields
 */
public extension JIRA {
    
    /**
     Definition of an issue field. This is the metadata describing a field
     */
    class IssueField : Object {
        
        /// The fields that have an attlasian document format, this is configurable
        public static var attlasianDocumentFieldKeys : Set<String> = ["description","environment"]
        
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
        public class Schema {
            
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
        public class Value : Object {
            
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
        
        /// Whether this is a text only field
        var textOnlyField : Bool {
            if schema?.fieldType ?? "" == "string" {
                return true
            }
            return false
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
        
        // MARK: - Serialization
        
        /**
            Serializes this field's value into a JSON Object (either an Array or a Dictionary) depending in the contents of the field. There're fields that have only one possible value (in allowedValues) or a value has been set in its value field
        */
        func serializeToJSONObject() -> Any? {
            if isReadOnly {
                var dictionary = [String:Any]()
                dictionary[JIRA.Object.JSONKeys.identifier.rawValue] = allowedValues!.first!.identifier ?? ""
                return dictionary
            } else if textOnlyField {
                
                if (key?.localizedLowercase ?? "") == "environment" {
                    return value?.serializeEnvironmentAsDocument()
                } else if IssueField.attlasianDocumentFieldKeys.contains(key ?? "") {
                    return value?.serializeDocument()
                }
                
                return value?.stringValue
            }
            return nil
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
