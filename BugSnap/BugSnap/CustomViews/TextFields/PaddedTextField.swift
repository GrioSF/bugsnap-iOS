//
//  PaddedTextField.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/20/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    TextField that has a padding useful for having some margin
*/
@IBDesignable public class PaddedTextField: UITextField {
    
    // MARK: - Padding
    
    /// The insets for the placeholder
    @IBInspectable var placeholderInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    /// The insets for the text edition
    @IBInspectable var textInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }


    // MARK: - Overrides
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let frame = super.textRect(forBounds: bounds)
        return frame.inset(by: textInsets)
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let frame = super.placeholderRect(forBounds: bounds)
        return frame.inset(by: placeholderInsets)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let frame = super.editingRect(forBounds: bounds)
        return frame.inset(by: textInsets)
    }

}
