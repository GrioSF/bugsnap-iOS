//
//  AbstractFormButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/27/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Abstract UIButton that allows to setup some visual configuration on it. Subclasses of this button should override the method configureButton to setup the visual features desired for the buttons.
*/
public class AbstractFormButton: UIButton {
    
    // MARK: - Private
    
    /// Whether it was previously configured
    private var wasConfigured = false

    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        configureButton()
    }
    
    convenience init(title: String) {
        self.init()
        setTitle(title, for: .normal)
    }
    
    // MARK: - Abstract Method
    
    /**
        This method doesn't do anything, it should be overriden by subclasses in order to setup some visual features for the button.
    */
    func configureButton() {
        guard !wasConfigured else { return }
        wasConfigured = true
    }
}
