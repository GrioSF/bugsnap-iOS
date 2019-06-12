//
//  MarkupButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/12/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Button that shows an image of a marker symbolizing a markup
*/
@IBDesignable public class MarkupButton: PathBasedButton {
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        
        /*  Shape   */
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 64, y: 7.875))
        pathRef.addCurve(to: CGPoint(x: 120.5, y: 64.375), control1: CGPoint(x: 95.781, y: 8.291), control2: CGPoint(x: 119.703, y: 32.883))
        pathRef.addCurve(to: CGPoint(x: 80.516, y: 117.79), control1: CGPoint(x: 120.319, y: 89.357), control2: CGPoint(x: 105.716, y: 112.637))
        pathRef.addCurve(to: CGPoint(x: 64.854, y: 120.125), control1: CGPoint(x: 80.516, y: 117.79), control2: CGPoint(x: 76.607, y: 120.125))
        pathRef.addCurve(to: CGPoint(x: 46.185, y: 118.425), control1: CGPoint(x: 52.854, y: 120.125), control2: CGPoint(x: 46.185, y: 118.425))
        pathRef.addCurve(to: CGPoint(x: 7.5, y: 64.375), control1: CGPoint(x: 20.536, y: 112.931), control2: CGPoint(x: 8.142, y: 89.737))
        pathRef.addCurve(to: CGPoint(x: 64, y: 7.875), control1: CGPoint(x: 7.5, y: 33.171), control2: CGPoint(x: 32.796, y: 7.875))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 66.874, y: 43.5))
        pathRef.addLine(to: CGPoint(x: 60.905, y: 43.5))
        pathRef.addLine(to: CGPoint(x: 60.096, y: 43.724))
        pathRef.addLine(to: CGPoint(x: 58.062, y: 53.737))
        pathRef.addLine(to: CGPoint(x: 48.067, y: 116.45))
        pathRef.addLine(to: CGPoint(x: 64.667, y: 117.85))
        pathRef.addLine(to: CGPoint(x: 78.453, y: 116.115))
        pathRef.addLine(to: CGPoint(x: 69.672, y: 53.737))
        pathRef.addLine(to: CGPoint(x: 67.596, y: 43.599))
        pathRef.addLine(to: CGPoint(x: 66.874, y: 43.5))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 64, y: 9.958))
        pathRef.addCurve(to: CGPoint(x: 9.583, y: 64.375), control1: CGPoint(x: 33.947, y: 9.958), control2: CGPoint(x: 9.583, y: 34.322))
        pathRef.addCurve(to: CGPoint(x: 46.597, y: 116.385), control1: CGPoint(x: 9.76, y: 88.372), control2: CGPoint(x: 22.361, y: 111.428))
        pathRef.addLine(to: CGPoint(x: 56.954, y: 51.879))
        pathRef.addLine(to: CGPoint(x: 59.001, y: 41.745))
        pathRef.addCurve(to: CGPoint(x: 60.055, y: 41.448), control1: CGPoint(x: 59.743, y: 41.539), control2: CGPoint(x: 59.391, y: 41.638))
        pathRef.addCurve(to: CGPoint(x: 61.489, y: 31.805), control1: CGPoint(x: 60.057, y: 38.183), control2: CGPoint(x: 60.422, y: 34.903))
        pathRef.addCurve(to: CGPoint(x: 64, y: 28.925), control1: CGPoint(x: 61.899, y: 30.615), control2: CGPoint(x: 62.631, y: 29.146))
        pathRef.addLine(to: CGPoint(x: 64, y: 28.925))
        pathRef.addCurve(to: CGPoint(x: 67.947, y: 41.525), control1: CGPoint(x: 67.746, y: 29.796), control2: CGPoint(x: 67.862, y: 38.831))
        pathRef.addCurve(to: CGPoint(x: 68.732, y: 41.745), control1: CGPoint(x: 68.342, y: 41.639), control2: CGPoint(x: 68.081, y: 41.564))
        pathRef.addLine(to: CGPoint(x: 70.779, y: 51.879))
        pathRef.addLine(to: CGPoint(x: 79.867, y: 115.85))
        pathRef.addCurve(to: CGPoint(x: 118.417, y: 64.375), control1: CGPoint(x: 104.525, y: 110.55), control2: CGPoint(x: 117.8, y: 88.746))
        pathRef.addCurve(to: CGPoint(x: 64, y: 9.958), control1: CGPoint(x: 118.417, y: 34.322), control2: CGPoint(x: 94.054, y: 9.958))
        pathRef.addLine(to: CGPoint(x: 64, y: 9.958))
        pathRef.closeSubpath()
        
        designSize = CGSize(width: 128.0, height: 128.0)
        pathStrokeColor = nil
        pathFillColor = UIColor.black
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 60))
        path = pathRef as CGPath
    }
}
