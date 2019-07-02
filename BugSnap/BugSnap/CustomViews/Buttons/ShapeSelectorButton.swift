//
//  ShapeSelectorButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/17/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Button with a plus sign to select a shape from a menu
*/
@IBDesignable public class ShapeSelectorButton: PathBasedButton {

    // MARK: - Override Path Based Button
    
    public override func configureButton() {
    
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 64, y: 17.167))
        pathRef.addCurve(to: CGPoint(x: 110.833, y: 64), control1: CGPoint(x: 89.865, y: 17.167), control2: CGPoint(x: 110.833, y: 38.135))
        pathRef.addCurve(to: CGPoint(x: 64, y: 110.833), control1: CGPoint(x: 110.833, y: 89.865), control2: CGPoint(x: 89.865, y: 110.833))
        pathRef.addCurve(to: CGPoint(x: 17.167, y: 64), control1: CGPoint(x: 38.135, y: 110.833), control2: CGPoint(x: 17.167, y: 89.865))
        pathRef.addCurve(to: CGPoint(x: 64, y: 17.167), control1: CGPoint(x: 17.167, y: 38.135), control2: CGPoint(x: 38.135, y: 17.167))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 64, y: 23.333))
        pathRef.addCurve(to: CGPoint(x: 23.333, y: 64), control1: CGPoint(x: 41.54, y: 23.333), control2: CGPoint(x: 23.333, y: 41.54))
        pathRef.addCurve(to: CGPoint(x: 64, y: 104.667), control1: CGPoint(x: 23.333, y: 86.46), control2: CGPoint(x: 41.54, y: 104.667))
        pathRef.addCurve(to: CGPoint(x: 104.667, y: 64), control1: CGPoint(x: 86.46, y: 104.667), control2: CGPoint(x: 104.667, y: 86.46))
        pathRef.addCurve(to: CGPoint(x: 64, y: 23.333), control1: CGPoint(x: 104.667, y: 41.54), control2: CGPoint(x: 86.46, y: 23.333))
        pathRef.closeSubpath()

        pathRef.move(to: CGPoint(x: 70.167, y: 40.167))
        pathRef.addLine(to: CGPoint(x: 70.167, y: 57.833))
        pathRef.addLine(to: CGPoint(x: 87.833, y: 57.833))
        pathRef.addLine(to: CGPoint(x: 87.833, y: 70.167))
        pathRef.addLine(to: CGPoint(x: 70.167, y: 70.167))
        pathRef.addLine(to: CGPoint(x: 70.167, y: 87.833))
        pathRef.addLine(to: CGPoint(x: 57.833, y: 87.833))
        pathRef.addLine(to: CGPoint(x: 57.833, y: 70.167))
        pathRef.addLine(to: CGPoint(x: 40.167, y: 70.167))
        pathRef.addLine(to: CGPoint(x: 40.167, y: 57.833))
        pathRef.addLine(to: CGPoint(x: 57.833, y: 57.833))
        pathRef.addLine(to: CGPoint(x: 57.833, y: 40.167))
        pathRef.addLine(to: CGPoint(x: 70.167, y: 40.167))
        pathRef.closeSubpath()
 
        designSize = CGSize(width: 128, height: 128)
        path = pathRef as CGPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 60))
        pathLineWidth = 0.0
        pathStrokeColor = nil
        pathFillColor = UIColor.black
    }

}
