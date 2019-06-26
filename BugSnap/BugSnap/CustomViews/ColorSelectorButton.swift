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
    
    
    /// Whether this button is selected, automatically changes the stroke color
    @IBInspectable public override var isSelected: Bool {
        didSet {
            if isSelected {
                cornerRadius = bounds.width * 0.5
                borderWidth = 1.0
                borderColor = UIColor.white
            } else {
                borderColor = nil
                borderWidth = 0.0
            }
        }
    }
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        let oval = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: 80, height: 80)))
        designSize = CGSize(width: 100, height: 100)
        path = oval.cgPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 38.0, height: 38.0))
        pathLineWidth = 1.0
        pathStrokeColor = UIColor.black
        pathFillColor = nil
        
        
    }

}
