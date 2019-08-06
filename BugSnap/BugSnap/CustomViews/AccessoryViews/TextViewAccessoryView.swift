//
//  TextViewAccessoryView.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/6/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Accessory view for a UITextView to allow resigning the keyboard when capturing a multiline text
*/
public class TextViewAccessoryView: UIView {
    
    // MARK: - Private Properties
    
    /// The main button contained in this accessory view
    private var doneButton : SubmitFormButton!
    
    /// The default value for the label
    public static let defaultButtonLabel = "Done"

    // MARK: - Initialization
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /**
        Initializes this accessory view.
        - Parameter buttonLabel: The label for the button included in the accessory view. The default value is "Done"
    */
    public init( buttonLabel : String = TextViewAccessoryView.defaultButtonLabel ) {
        super.init(frame: CGRect.zero)
        setup(buttonLabel: buttonLabel)
    }
    
    // MARK: - Convenience methods
    
    /**
        Adds a handler for the only button contained within this accessory view. The main purpose of this button should be dismissing the keyboard (resigning the first responder).
        - Parameter target: The instance of the object to which the action message will be sent
        - Parameter action: The message sent to the target when the button is tapped (the primary action)
    */
    public func addTarget( _ target : Any? , action : Selector ) {
        doneButton.addTarget(target, action: action, for: .primaryActionTriggered)
    }
    
    // MARK: - Setup
    
    private func setup( buttonLabel : String = TextViewAccessoryView.defaultButtonLabel ) {
        let toolbar = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        doneButton = SubmitFormButton(title: buttonLabel)
        doneButton.cornerRadius = 5.0
        toolbar.contentView.addSubview(doneButton)
        doneButton.trailingAnchor.constraint(equalTo: toolbar.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20.0).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: toolbar.contentView.centerYAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        
        // Setup the view
        frame = CGRect(x: 0, y: 0, width: 200.0, height: 42.0)
        backgroundColor = UIColor.clear
        addSubview(toolbar)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[toolbar]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["toolbar":toolbar]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[toolbar]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["toolbar":toolbar]))
    }

}
