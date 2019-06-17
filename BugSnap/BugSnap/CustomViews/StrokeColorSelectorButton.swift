//
//  StrokeColorSelectorButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/14/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Path representing the current stroke color for the tools. The button will represent in its shape
    the color selected for stroke. When no color is selected it won't fill up the path.
*/
@IBDesignable public class StrokeColorSelectorButton: PathBasedButton {

    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        
        /*  Shape   */
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 114, y: 14))
        pathRef.addLine(to: CGPoint(x: 114, y: 114))
        pathRef.addLine(to: CGPoint(x: 14, y: 114))
        pathRef.addLine(to: CGPoint(x: 14, y: 14))
        pathRef.addLine(to: CGPoint(x: 114, y: 14))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 104, y: 24))
        pathRef.addLine(to: CGPoint(x: 24, y: 24))
        pathRef.addLine(to: CGPoint(x: 24, y: 104))
        pathRef.addLine(to: CGPoint(x: 104, y: 104))
        pathRef.addLine(to: CGPoint(x: 104, y: 24))
        pathRef.closeSubpath()

        keepAspectRatio = false
        designSize = CGSize(width: 128.0, height: 128.0)
        pathStrokeColor = UIColor.black
        pathFillColor = nil
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40.0, height: 40))
        path = pathRef as CGPath
    }

}
