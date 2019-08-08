//
//  ScreenRecordingButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/5/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

@IBDesignable public class ScreenRecordingButton: PathBasedButton {

    // MARK: - Override Path Based Button
    
    public override func configureButton() {

        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 25.3, y: 38.7))
        pathRef.addLine(to: CGPoint(x: 69.508, y: 38.7))
        pathRef.addCurve(to: CGPoint(x: 77.694, y: 46.899), control1: CGPoint(x: 74.029, y: 38.7), control2: CGPoint(x: 77.694, y: 42.371))
        pathRef.addLine(to: CGPoint(x: 77.694, y: 81.101))
        pathRef.addCurve(to: CGPoint(x: 69.508, y: 89.3), control1: CGPoint(x: 77.694, y: 85.629), control2: CGPoint(x: 74.029, y: 89.3))
        pathRef.addLine(to: CGPoint(x: 25.3, y: 89.3))
        pathRef.addCurve(to: CGPoint(x: 17.114, y: 81.101), control1: CGPoint(x: 20.779, y: 89.3), control2: CGPoint(x: 17.114, y: 85.629))
        pathRef.addLine(to: CGPoint(x: 17.114, y: 46.899))
        pathRef.addCurve(to: CGPoint(x: 25.3, y: 38.7), control1: CGPoint(x: 17.114, y: 42.371), control2: CGPoint(x: 20.779, y: 38.7))
        pathRef.closeSubpath()

        pathRef.move(to: CGPoint(x: 110.886, y: 41.485))
        pathRef.addCurve(to: CGPoint(x: 83.961, y: 52.859), control1: CGPoint(x: 110.886, y: 41.717), control2: CGPoint(x: 83.729, y: 53.091))
        pathRef.addCurve(to: CGPoint(x: 84.194, y: 72.124), control1: CGPoint(x: 84.194, y: 52.627), control2: CGPoint(x: 83.961, y: 72.124))
        pathRef.addCurve(to: CGPoint(x: 110.654, y: 85.586), control1: CGPoint(x: 84.426, y: 72.124), control2: CGPoint(x: 110.422, y: 85.586))
        pathRef.addCurve(to: CGPoint(x: 110.886, y: 41.485), control1: CGPoint(x: 110.886, y: 85.586), control2: CGPoint(x: 110.886, y: 41.717))
        pathRef.closeSubpath()

        designSize = CGSize(width: 128, height: 128)
        path = pathRef as CGPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 36, height: 36))
        pathLineWidth = 0.0
        pathStrokeColor = nil
        pathFillColor = UIColor.white
    }

}
