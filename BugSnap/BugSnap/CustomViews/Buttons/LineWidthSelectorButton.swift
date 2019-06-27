//
//  LineWidthSelectorButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/14/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    A button to represent different line widths (this button should launch the line width selector).
*/
@IBDesignable public class LineWidthSelectorButton: PathBasedButton {
    
    // MARK: - Override PathBasedButton
    
    public override func configureButton() {
        
        /*  Shape   */
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 114, y: 89.8))
        pathRef.addLine(to: CGPoint(x: 114, y: 115.6))
        pathRef.addLine(to: CGPoint(x: 14, y: 115.6))
        pathRef.addLine(to: CGPoint(x: 14, y: 89.8))
        pathRef.addLine(to: CGPoint(x: 114, y: 89.8))
        pathRef.closeSubpath()
        
        pathRef.move(to: CGPoint(x: 114, y: 57))
        pathRef.addLine(to: CGPoint(x: 114, y: 74.8))
        pathRef.addLine(to: CGPoint(x: 14, y: 74.8))
        pathRef.addLine(to: CGPoint(x: 14, y: 57))
        pathRef.addLine(to: CGPoint(x: 114, y: 57))
        pathRef.closeSubpath()

        pathRef.move(to: CGPoint(x: 114, y: 32))
        pathRef.addLine(to: CGPoint(x: 114, y: 43.8))
        pathRef.addLine(to: CGPoint(x: 14, y: 43.8))
        pathRef.addLine(to: CGPoint(x: 14, y: 32))
        pathRef.addLine(to: CGPoint(x: 114, y: 32))
        pathRef.closeSubpath()

        pathRef.move(to: CGPoint(x: 114, y: 14))
        pathRef.addLine(to: CGPoint(x: 114, y: 18.6))
        pathRef.addLine(to: CGPoint(x: 14, y: 18.6))
        pathRef.addLine(to: CGPoint(x: 14, y: 14))
        pathRef.addLine(to: CGPoint(x: 114, y: 14))
        pathRef.closeSubpath()
        
        keepAspectRatio = false
        designSize = CGSize(width: 128.0, height: 128.0)
        pathStrokeColor = nil
        pathFillColor = UIColor.black
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 60.0, height: 40))
        path = pathRef as CGPath
    }
}
