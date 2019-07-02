//
//  AbstractFormLabel.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/27/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Label designed mostly for providing a way to setup some customization in its subclasses.
*/
@IBDesignable public class AbstractFormLabel: UILabel {
    
    // MARK: - Private
    
    /// Whether it was previously configured
    private var wasConfigured = false

    // MARK: - Initialization
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLabel()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        configureLabel()
    }
    
    convenience init(text : String) {
        self.init()
        self.text = text
    }
    
    // MARK: - Setup
    
    /**
        Sets up the customization for this label. Basically it should set the font and some other features of UILabel.
        This implementation is empty and is intended to be overriden by subclasses.
    */
    func configureLabel() {
        guard !wasConfigured else { return }
        wasConfigured = true
    }
}
