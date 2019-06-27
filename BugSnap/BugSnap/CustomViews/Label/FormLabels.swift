//
//  FormLabels.swift
//  BugSnap
//  Labels used in the JIRA Forms
//
//  Created by Héctor García Peña on 6/27/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Label intended to be the title of a form. It shares its configu
*/
@IBDesignable public class FormTitleLabel: AbstractFormLabel {

    // MARK: - Implement Abstract Method
    
    public override func configureLabel() {
        super.configureLabel()
        backgroundColor = UIColor.clear
        textColor = UIColor.darkGray
        textAlignment = .center
        numberOfLines = 0
        font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

/**
    Label intended to be the name of a field (above the capture field)
*/
@IBDesignable public class FieldNameLabel : AbstractFormLabel {
    
    // MARK: - Implement Abstract Method
    
    public override func configureLabel() {
        super.configureLabel()
        textColor = UIColor(red: 137, green: 137, blue: 137)
        textAlignment = .left
        font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

/**
    Label inteded to be the used in the accessory view that suggest data from JIRA.
*/
@IBDesignable public class AutoSuggestLabel : AbstractFormLabel {
    
    // MARK: - Implement label configuration
    
    public override func configureLabel() {
        super.configureLabel()
        
        font = UIFont.preferredFont(forTextStyle: .body)
        backgroundColor = UIColor(red: 208, green: 210, blue: 217)
        textColor = UIColor.darkText
        isUserInteractionEnabled = true
        textAlignment = .center
        sizeToFit()
    }
    
    // MARK: - Utitlity methods
    
    /**
        Adds a tap gesture recognizer to this label, thus enabling user interaction
        - Parameter target: The receiver for the action of this label when the user taps
        - Parameter action: The method that should be called when the user taps on this label
    */
    public func addTap( target : NSObject, action: Selector ) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        gesture.numberOfTapsRequired = 1
        addGestureRecognizer(gesture)
    }
    
    /**
        Adds a line at the end of this label to simulate a separator between labels
    */
    public func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = UIColor.gray
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        separator.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        separator.topAnchor.constraint(equalTo: topAnchor, constant: 5.0).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0).isActive = true
        separator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
