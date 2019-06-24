//
//  UIColor+Helpers.swift
//  Utilities for UIColor through an extension
//  BugSnap
//
//  Created by Héctor García Peña on 6/20/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation
import UIKit

/**
    Utility and factory methods for UIColor
*/
public extension UIColor {
    
    
    /**
        Initializer of a color with Integer arguments that vary between 0-255
        - Parameter red: The red component of the color (0-255)
        - Parameter green: The red component of the color (0-255)
        - Parameter blue: The blue component of the color (0-255)
    */
    convenience init(red : Int, green : Int , blue : Int) {
        let vRed = CGFloat(min(max(red,0),255))/255.0
        let vGreen = CGFloat(min(max(green,0),255))/255.0
        let vBlue = CGFloat(min(max(blue,0),255))/255.0
        self.init(red: vRed, green: vGreen, blue: vBlue, alpha: 1.0)
    }
}
