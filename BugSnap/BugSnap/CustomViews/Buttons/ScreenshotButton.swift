//
//  ScreenshotButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/5/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

@IBDesignable public class ScreenshotButton: PathBasedButton {
    
    // MARK: - Override Path Based Button
    
    public override func configureButton() {

        /*  Shape   */
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 62.374, y: 25.207))
        pathRef.addCurve(to: CGPoint(x: 80.618, y: 26.524), control1: CGPoint(x: 67.792, y: 25.417), control2: CGPoint(x: 75.402, y: 24.951))
        pathRef.addCurve(to: CGPoint(x: 86.677, y: 34.205), control1: CGPoint(x: 83.689, y: 28.045), control2: CGPoint(x: 85.185, y: 31.318))
        pathRef.addLine(to: CGPoint(x: 96.257, y: 34.205))
        pathRef.addCurve(to: CGPoint(x: 110.248, y: 48.155), control1: CGPoint(x: 103.984, y: 34.205), control2: CGPoint(x: 110.248, y: 40.451))
        pathRef.addLine(to: CGPoint(x: 110.248, y: 88.843))
        pathRef.addCurve(to: CGPoint(x: 96.257, y: 102.793), control1: CGPoint(x: 110.248, y: 96.548), control2: CGPoint(x: 103.984, y: 102.793))
        pathRef.addLine(to: CGPoint(x: 31.743, y: 102.793))
        pathRef.addCurve(to: CGPoint(x: 17.752, y: 88.843), control1: CGPoint(x: 24.016, y: 102.793), control2: CGPoint(x: 17.752, y: 96.548))
        pathRef.addLine(to: CGPoint(x: 17.752, y: 48.155))
        pathRef.addCurve(to: CGPoint(x: 31.743, y: 34.205), control1: CGPoint(x: 17.752, y: 40.451), control2: CGPoint(x: 24.016, y: 34.205))
        pathRef.addLine(to: CGPoint(x: 43.77, y: 34.205))
        pathRef.addCurve(to: CGPoint(x: 48.166, y: 26.759), control1: CGPoint(x: 44.113, y: 31.013), control2: CGPoint(x: 45.293, y: 28.289))
        pathRef.addCurve(to: CGPoint(x: 62.374, y: 25.207), control1: CGPoint(x: 52.705, y: 25.238), control2: CGPoint(x: 57.647, y: 25.352))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 64, y: 43.69))
        pathRef.addCurve(to: CGPoint(x: 39.779, y: 67.911), control1: CGPoint(x: 50.623, y: 43.69), control2: CGPoint(x: 39.779, y: 54.534))
        pathRef.addCurve(to: CGPoint(x: 64, y: 92.133), control1: CGPoint(x: 39.779, y: 81.289), control2: CGPoint(x: 50.623, y: 92.133))
        pathRef.addCurve(to: CGPoint(x: 88.221, y: 67.911), control1: CGPoint(x: 77.377, y: 92.133), control2: CGPoint(x: 88.221, y: 81.289))
        pathRef.addCurve(to: CGPoint(x: 64, y: 43.69), control1: CGPoint(x: 88.221, y: 54.534), control2: CGPoint(x: 77.377, y: 43.69))
        pathRef.closeSubpath()

        pathRef.move(to: CGPoint(x: 64, y: 84.96))
        pathRef.addCurve(to: CGPoint(x: 46.951, y: 67.911), control1: CGPoint(x: 54.584, y: 84.96), control2: CGPoint(x: 46.951, y: 77.327))
        pathRef.addCurve(to: CGPoint(x: 64, y: 50.862), control1: CGPoint(x: 46.951, y: 58.496), control2: CGPoint(x: 54.584, y: 50.862))
        pathRef.addCurve(to: CGPoint(x: 81.049, y: 67.911), control1: CGPoint(x: 73.416, y: 50.862), control2: CGPoint(x: 81.049, y: 58.496))
        pathRef.addCurve(to: CGPoint(x: 64, y: 84.96), control1: CGPoint(x: 81.049, y: 77.327), control2: CGPoint(x: 73.416, y: 84.96))
        pathRef.closeSubpath()

        designSize = CGSize(width: 128, height: 128)
        path = pathRef as CGPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 36, height: 36))
        pathLineWidth = 0.0
        pathStrokeColor = nil
        pathFillColor = UIColor.white
    }
}
