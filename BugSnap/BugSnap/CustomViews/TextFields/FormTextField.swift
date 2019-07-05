//
//  FormTextField.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/27/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Text Field present in the JIRA Capture Form with common visual configuration.
*/
@IBDesignable public class FormTextField: PaddedTextField {
    
    // MARK: - Private
    
    /// Whether it was previously configured
    private var wasConfigured = false

    // MARK: - Initialization
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureTextField()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        configureTextField()
    }
    
    // MARK: - Configuration
    
    /**
        Configures the common visual features for the text field.
        When you subclass this text field you should override the configuration
    */
    func configureTextField() {
        guard !wasConfigured else { return }
        
        backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        textColor = UIColor.black
        textAlignment = .left
        autocapitalizationType = .none
        textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        translatesAutoresizingMaskIntoConstraints = false
        returnKeyType = .continue
    }

}
