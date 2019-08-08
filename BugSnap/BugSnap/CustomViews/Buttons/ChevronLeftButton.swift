//
//  ChevronLeftButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/6/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Button with a path represeting a chevron pointing to the left (a back button)
*/
class ChevronLeftButton: PathBasedButton {

    // MARK: - Override Path Based Button
    
    public override func configureButton() {
        
        
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 82.351, y: 36.27))
        pathRef.addCurve(to: CGPoint(x: 42.362, y: 64.011), control1: CGPoint(x: 80.199, y: 37.381), control2: CGPoint(x: 42.362, y: 64.011))
        pathRef.addCurve(to: CGPoint(x: 82.007, y: 91.753), control1: CGPoint(x: 42.362, y: 64.011), control2: CGPoint(x: 81.119, y: 91.372))
        pathRef.addCurve(to: CGPoint(x: 85.454, y: 87.92), control1: CGPoint(x: 83.454, y: 92.373), control2: CGPoint(x: 86.04, y: 89.198))
        pathRef.addCurve(to: CGPoint(x: 51.669, y: 63.829), control1: CGPoint(x: 85.048, y: 87.036), control2: CGPoint(x: 51.669, y: 63.829))
        pathRef.addCurve(to: CGPoint(x: 85.454, y: 39.92), control1: CGPoint(x: 51.669, y: 63.829), control2: CGPoint(x: 84.919, y: 40.508))
        pathRef.addCurve(to: CGPoint(x: 82.351, y: 36.27), control1: CGPoint(x: 86.35, y: 38.934), control2: CGPoint(x: 83.765, y: 35.54))
        pathRef.closeSubpath()


        designSize = CGSize(width: 128, height: 128)
        path = pathRef as CGPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40.0, height: 40.0))
        pathLineWidth = 0.0
        pathStrokeColor = nil
        pathFillColor = UIColor.black
    }

}
