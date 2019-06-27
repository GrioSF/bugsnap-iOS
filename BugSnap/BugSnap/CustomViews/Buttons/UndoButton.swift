//
//  UndoButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/17/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Button to represent a undo
*/
public class UndoButton: PathBasedButton {
    
    public override var isEnabled: Bool {
        didSet {
            pathFillColor = isEnabled ? UIColor.black : UIColor.gray
        }
    }

    // MARK: - PathBasedButton override
    
    public override func configureButton() {
      
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 69.625, y: 59.5))
        pathRef.addLine(to: CGPoint(x: 24.625, y: 39.25))
        pathRef.addLine(to: CGPoint(x: 69.625, y: 19))
        pathRef.closeSubpath()

        pathRef.move(to: CGPoint(x: 64, y: 37))
        pathRef.addLine(to: CGPoint(x: 58.375, y: 37.46))
        pathRef.addLine(to: CGPoint(x: 58.375, y: 41.955))
        pathRef.addLine(to: CGPoint(x: 64, y: 41.5))
        pathRef.addCurve(to: CGPoint(x: 103.375, y: 73), control1: CGPoint(x: 85.746, y: 41.5), control2: CGPoint(x: 103.375, y: 55.603))
        pathRef.addCurve(to: CGPoint(x: 64, y: 104.5), control1: CGPoint(x: 103.375, y: 90.397), control2: CGPoint(x: 85.746, y: 104.5))
        pathRef.addCurve(to: CGPoint(x: 24.625, y: 73), control1: CGPoint(x: 42.254, y: 104.5), control2: CGPoint(x: 24.625, y: 90.397))
        pathRef.addCurve(to: CGPoint(x: 26.745, y: 64), control1: CGPoint(x: 25.097, y: 67.281), control2: CGPoint(x: 24.496, y: 70.295))
        pathRef.addLine(to: CGPoint(x: 20.948, y: 64))
        pathRef.addCurve(to: CGPoint(x: 19, y: 73), control1: CGPoint(x: 18.855, y: 69.951), control2: CGPoint(x: 19.489, y: 66.949))
        pathRef.addCurve(to: CGPoint(x: 64, y: 109), control1: CGPoint(x: 19, y: 92.882), control2: CGPoint(x: 39.147, y: 109))
        pathRef.addCurve(to: CGPoint(x: 109, y: 73), control1: CGPoint(x: 88.853, y: 109), control2: CGPoint(x: 109, y: 92.882))
        pathRef.addCurve(to: CGPoint(x: 64, y: 37), control1: CGPoint(x: 109, y: 53.118), control2: CGPoint(x: 88.853, y: 37))
        pathRef.closeSubpath()
        
        designSize = CGSize(width: 128.0, height: 128.0)
        pathStrokeColor = nil
        pathFillColor = UIColor.black
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 60))
        path = pathRef as CGPath
    }

}
