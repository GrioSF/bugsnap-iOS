//
//  FormsButtons.swift
//  BugSnap
//  Buttons present in the JIRA forms
//  Created by Héctor García Peña on 6/27/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
    Button for a submit action. This comes from the design given during development.
*/
@IBDesignable public class SubmitFormButton : AbstractFormButton {
    
    // MARK: - Override configure button
    
    public override func configureButton() {
        super.configureButton()
        
        backgroundColor = UIColor(red: 49, green: 113, blue: 246)
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        cornerRadius = 2.0
        translatesAutoresizingMaskIntoConstraints = false
    }
}

/**
    Button for a cancel action. This comes from the design given during development.
*/
@IBDesignable public class CancelFormButton : AbstractFormButton {
    
    // MARK: - Override
    
    public override func configureButton() {
        super.configureButton()
        backgroundColor = UIColor.white
        setTitleColor(UIColor(red: 137, green: 137, blue: 137), for: .normal)
        titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
