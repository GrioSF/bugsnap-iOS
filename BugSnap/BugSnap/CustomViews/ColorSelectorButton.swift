//
//  ColorSelectorButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/12/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import UIKit

/**
    A button for selecting a color. This button will contain a circle and a border of 2 points width.
    The fill color will be the selected color by the user. Setting the stroke color to black (or another color)
    will let the user know if the button was selected
*/
@IBDesignable public class ColorSelectorButton: PathBasedButton {
    
    /// The color when the color is actually selected
    @IBInspectable var selectedColor : UIColor = UIColor.black {
        didSet {
            pathStrokeColor = isSelected ? selectedColor : nil
        }
    }
    
    /// Whether this button is selected, automatically changes the stroke color
    @IBInspectable public override var isSelected: Bool {
        didSet {
            pathStrokeColor = isSelected ? selectedColor : nil
        }
    }
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        let oval = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 80, height: 80)))
        designSize = CGSize(width: 120, height: 120)
        path = oval.cgPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 60))
        pathLineWidth = 2.0
        pathStrokeColor = UIColor.black
        pathFillColor = UIColor.orange
    }

}
