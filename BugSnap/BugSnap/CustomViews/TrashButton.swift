//
//  TrashButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

class TrashButton: PathBasedButton {

    // MARK: - Override Path Based Button
    
    public override func configureButton() {
        /*  Shape   */
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 100.125, y: 38.875))
        pathRef.addLine(to: CGPoint(x: 89.375, y: 103.875))
        pathRef.addCurve(to: CGPoint(x: 78.625, y: 114.125), control1: CGPoint(x: 87.625, y: 110.375), control2: CGPoint(x: 83.82, y: 114.125))
        pathRef.addLine(to: CGPoint(x: 50.625, y: 114.375))
        pathRef.addCurve(to: CGPoint(x: 39.625, y: 103.375), control1: CGPoint(x: 45.43, y: 114.375), control2: CGPoint(x: 42.625, y: 109.875))
        pathRef.addLine(to: CGPoint(x: 29.875, y: 39.125))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 35.125, y: 40.375))
        pathRef.addLine(to: CGPoint(x: 43.753, y: 100.036))
        pathRef.addCurve(to: CGPoint(x: 53.244, y: 110.25), control1: CGPoint(x: 46.342, y: 106.071), control2: CGPoint(x: 48.762, y: 110.25))
        pathRef.addLine(to: CGPoint(x: 77.403, y: 110.018))
        pathRef.addCurve(to: CGPoint(x: 86.678, y: 100.5), control1: CGPoint(x: 81.885, y: 110.018), control2: CGPoint(x: 85.168, y: 106.536))
        pathRef.addLine(to: CGPoint(x: 94.875, y: 40.125))
        pathRef.addCurve(to: CGPoint(x: 35.125, y: 40.375), control1: CGPoint(x: 94.625, y: 39.661), control2: CGPoint(x: 35.375, y: 40.125))
        pathRef.closeSubpath()

        /*  Shape 2  */
        let pathRef2 = pathRef
        pathRef2.move(to: CGPoint(x: 102.661, y: 26.125))
        pathRef2.addCurve(to: CGPoint(x: 108.875, y: 33.25), control1: CGPoint(x: 106.093, y: 26.125), control2: CGPoint(x: 108.875, y: 29.315))
        pathRef2.addCurve(to: CGPoint(x: 102.661, y: 40.375), control1: CGPoint(x: 108.875, y: 37.185), control2: CGPoint(x: 106.093, y: 40.375))
        pathRef2.addLine(to: CGPoint(x: 27.338, y: 40.375))
        pathRef2.addCurve(to: CGPoint(x: 21.125, y: 33.25), control1: CGPoint(x: 23.907, y: 40.375), control2: CGPoint(x: 21.125, y: 37.185))
        pathRef2.addCurve(to: CGPoint(x: 27.339, y: 26.125), control1: CGPoint(x: 21.125, y: 29.315), control2: CGPoint(x: 23.907, y: 26.125))
        pathRef2.addLine(to: CGPoint(x: 102.661, y: 26.125))
        pathRef2.closeSubpath()
        pathRef2.move(to: CGPoint(x: 98.888, y: 30.176))
        pathRef2.addLine(to: CGPoint(x: 30.862, y: 30.176))
        pathRef2.addCurve(to: CGPoint(x: 25.25, y: 33.529), control1: CGPoint(x: 27.762, y: 30.176), control2: CGPoint(x: 25.25, y: 31.678))
        pathRef2.addCurve(to: CGPoint(x: 30.862, y: 36.882), control1: CGPoint(x: 25.25, y: 35.381), control2: CGPoint(x: 27.762, y: 36.882))
        pathRef2.addLine(to: CGPoint(x: 98.888, y: 36.882))
        pathRef2.addCurve(to: CGPoint(x: 104.5, y: 33.529), control1: CGPoint(x: 101.988, y: 36.882), control2: CGPoint(x: 104.5, y: 35.381))
        pathRef2.addCurve(to: CGPoint(x: 98.888, y: 30.176), control1: CGPoint(x: 104.5, y: 31.678), control2: CGPoint(x: 101.988, y: 30.176))
        pathRef2.closeSubpath()

        
        /*  Shape 3  */
        let pathRef3 = pathRef
        pathRef3.move(to: CGPoint(x: 75.375, y: 26.125))
        pathRef3.addLine(to: CGPoint(x: 72.8, y: 20.637))
        pathRef3.addLine(to: CGPoint(x: 57.4, y: 20.5))
        pathRef3.addLine(to: CGPoint(x: 54.375, y: 26.125))
        pathRef3.addLine(to: CGPoint(x: 48.625, y: 26.125))
        pathRef3.addLine(to: CGPoint(x: 55.375, y: 15.875))
        pathRef3.addLine(to: CGPoint(x: 74.625, y: 16.125))
        pathRef3.addLine(to: CGPoint(x: 81.125, y: 26.125))
        pathRef3.addLine(to: CGPoint(x: 75.375, y: 26.125))
        pathRef3.closeSubpath()

        
        /*  Shape 4  */
        let pathRef4 = pathRef
        pathRef4.move(to: CGPoint(x: 62.875, y: 47.875))
        pathRef4.addLine(to: CGPoint(x: 66.875, y: 47.875))
        pathRef4.addLine(to: CGPoint(x: 66.875, y: 98.625))
        pathRef4.addLine(to: CGPoint(x: 62.875, y: 98.625))
        pathRef4.addLine(to: CGPoint(x: 62.875, y: 47.875))
        pathRef4.closeSubpath()
        
        /*  Shape 5  */
        let pathRef5 = pathRef
        pathRef5.move(to: CGPoint(x: 76.88, y: 47.807))
        pathRef5.addLine(to: CGPoint(x: 80.875, y: 48.006))
        pathRef5.addLine(to: CGPoint(x: 78.344, y: 98.693))
        pathRef5.addLine(to: CGPoint(x: 74.349, y: 98.494))
        pathRef5.addLine(to: CGPoint(x: 76.88, y: 47.807))
        pathRef5.closeSubpath()
        
        /*  Shape 6  */
        let pathRef6 = pathRef
        pathRef6.move(to: CGPoint(x: 48.625, y: 48.023))
        pathRef6.addLine(to: CGPoint(x: 52.619, y: 47.804))
        pathRef6.addLine(to: CGPoint(x: 55.399, y: 98.477))
        pathRef6.addLine(to: CGPoint(x: 51.405, y: 98.696))
        pathRef6.addLine(to: CGPoint(x: 48.625, y: 48.023))
        pathRef6.closeSubpath()
        
        designSize = CGSize(width: 128, height: 128)
        path = pathRef as CGPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 36, height: 36))
        pathLineWidth = 0.0
        pathStrokeColor = nil
        pathFillColor = UIColor.white
    }

}
