//
//  TextToolButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

@IBDesignable public class TextToolButton: ToolbarSelectableButton {

    // MARK: - Override Path Based Button
    
    public override func configureButton() {
        
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 91.914, y: 21.641))
        pathRef.addLine(to: CGPoint(x: 92.5, y: 34.062))
        pathRef.addLine(to: CGPoint(x: 91.016, y: 34.062))
        pathRef.addQuadCurve(to: CGPoint(x: 89.844, y: 29.375), control: CGPoint(x: 90.586, y: 30.781))
        pathRef.addQuadCurve(to: CGPoint(x: 86.621, y: 26.035), control: CGPoint(x: 88.633, y: 27.109))
        pathRef.addQuadCurve(to: CGPoint(x: 81.328, y: 24.961), control: CGPoint(x: 84.609, y: 24.961))
        pathRef.addLine(to: CGPoint(x: 66.992, y: 25.812))
        pathRef.addLine(to: CGPoint(x: 66.992, y: 63.633))
        pathRef.addQuadCurve(to: CGPoint(x: 68.047, y: 69.727), control: CGPoint(x: 66.992, y: 68.516))
        pathRef.addQuadCurve(to: CGPoint(x: 72.617, y: 71.367), control: CGPoint(x: 69.531, y: 71.367))
        pathRef.addLine(to: CGPoint(x: 74.453, y: 71.367))
        pathRef.addLine(to: CGPoint(x: 74.453, y: 72.812))
        pathRef.addLine(to: CGPoint(x: 51.992, y: 72.812))
        pathRef.addLine(to: CGPoint(x: 51.992, y: 71.367))
        pathRef.addLine(to: CGPoint(x: 53.867, y: 71.367))
        pathRef.addQuadCurve(to: CGPoint(x: 58.633, y: 69.336), control: CGPoint(x: 57.227, y: 71.367))
        pathRef.addQuadCurve(to: CGPoint(x: 59.492, y: 63.633), control: CGPoint(x: 59.492, y: 68.086))
        pathRef.addLine(to: CGPoint(x: 59.492, y: 25.812))
        pathRef.addLine(to: CGPoint(x: 46.828, y: 24.961))
        pathRef.addQuadCurve(to: CGPoint(x: 41.555, y: 25.508), control: CGPoint(x: 43.117, y: 24.961))
        pathRef.addQuadCurve(to: CGPoint(x: 38.078, y: 28.359), control: CGPoint(x: 39.523, y: 26.25))
        pathRef.addQuadCurve(to: CGPoint(x: 36.359, y: 34.062), control: CGPoint(x: 36.633, y: 30.469))
        pathRef.addLine(to: CGPoint(x: 34.875, y: 34.062))
        pathRef.addLine(to: CGPoint(x: 35.5, y: 21.641))
        pathRef.closeSubpath()
        
        /*  Shape 2  */
        let pathRef2 = pathRef
        pathRef2.move(to: CGPoint(x: 21.465, y: 84.299))
        pathRef2.addLine(to: CGPoint(x: 21.465, y: 86.619))
        pathRef2.addLine(to: CGPoint(x: 31.385, y: 86.619))
        pathRef2.addLine(to: CGPoint(x: 31.385, y: 112.859))
        pathRef2.addLine(to: CGPoint(x: 34.105, y: 112.859))
        pathRef2.addLine(to: CGPoint(x: 34.105, y: 86.619))
        pathRef2.addLine(to: CGPoint(x: 44.065, y: 86.619))
        pathRef2.addLine(to: CGPoint(x: 44.065, y: 84.299))
        pathRef2.closeSubpath()
        
        /*  Shape 3  */
        let pathRef3 = pathRef
        pathRef3.move(to: CGPoint(x: 60.915, y: 101.099))
        pathRef3.addLine(to: CGPoint(x: 47.555, y: 101.099))
        pathRef3.addQuadCurve(to: CGPoint(x: 48.215, y: 98.359), control: CGPoint(x: 47.715, y: 99.699))
        pathRef3.addQuadCurve(to: CGPoint(x: 49.555, y: 95.999), control: CGPoint(x: 48.715, y: 97.019))
        pathRef3.addQuadCurve(to: CGPoint(x: 51.595, y: 94.359), control: CGPoint(x: 50.395, y: 94.979))
        pathRef3.addQuadCurve(to: CGPoint(x: 54.355, y: 93.739), control: CGPoint(x: 52.795, y: 93.739))
        pathRef3.addQuadCurve(to: CGPoint(x: 57.075, y: 94.359), control: CGPoint(x: 55.875, y: 93.739))
        pathRef3.addQuadCurve(to: CGPoint(x: 59.115, y: 95.999), control: CGPoint(x: 58.275, y: 94.979))
        pathRef3.addQuadCurve(to: CGPoint(x: 60.415, y: 98.339), control: CGPoint(x: 59.955, y: 97.019))
        pathRef3.addQuadCurve(to: CGPoint(x: 60.915, y: 101.099), control: CGPoint(x: 60.875, y: 99.659))
        pathRef3.closeSubpath()
        pathRef3.move(to: CGPoint(x: 47.555, y: 103.219))
        pathRef3.addLine(to: CGPoint(x: 63.435, y: 103.219))
        pathRef3.addQuadCurve(to: CGPoint(x: 63.035, y: 98.959), control: CGPoint(x: 63.515, y: 101.059))
        pathRef3.addQuadCurve(to: CGPoint(x: 61.455, y: 95.239), control: CGPoint(x: 62.555, y: 96.859))
        pathRef3.addQuadCurve(to: CGPoint(x: 58.595, y: 92.619), control: CGPoint(x: 60.355, y: 93.619))
        pathRef3.addQuadCurve(to: CGPoint(x: 54.355, y: 91.619), control: CGPoint(x: 56.835, y: 91.619))
        pathRef3.addQuadCurve(to: CGPoint(x: 50.135, y: 92.559), control: CGPoint(x: 51.915, y: 91.619))
        pathRef3.addQuadCurve(to: CGPoint(x: 47.235, y: 95.039), control: CGPoint(x: 48.355, y: 93.499))
        pathRef3.addQuadCurve(to: CGPoint(x: 45.575, y: 98.539), control: CGPoint(x: 46.115, y: 96.579))
        pathRef3.addQuadCurve(to: CGPoint(x: 45.035, y: 102.539), control: CGPoint(x: 45.035, y: 100.499))
        pathRef3.addQuadCurve(to: CGPoint(x: 45.575, y: 106.719), control: CGPoint(x: 45.035, y: 104.739))
        pathRef3.addQuadCurve(to: CGPoint(x: 47.235, y: 110.199), control: CGPoint(x: 46.115, y: 108.699))
        pathRef3.addQuadCurve(to: CGPoint(x: 50.135, y: 112.559), control: CGPoint(x: 48.355, y: 111.699))
        pathRef3.addQuadCurve(to: CGPoint(x: 54.355, y: 113.419), control: CGPoint(x: 51.915, y: 113.419))
        pathRef3.addQuadCurve(to: CGPoint(x: 60.415, y: 111.499), control: CGPoint(x: 58.275, y: 113.419))
        pathRef3.addQuadCurve(to: CGPoint(x: 63.355, y: 106.059), control: CGPoint(x: 62.555, y: 109.579))
        pathRef3.addLine(to: CGPoint(x: 60.835, y: 106.059))
        pathRef3.addQuadCurve(to: CGPoint(x: 58.675, y: 109.899), control: CGPoint(x: 60.235, y: 108.459))
        pathRef3.addQuadCurve(to: CGPoint(x: 54.355, y: 111.339), control: CGPoint(x: 57.115, y: 111.339))
        pathRef3.addQuadCurve(to: CGPoint(x: 51.275, y: 110.579), control: CGPoint(x: 52.555, y: 111.339))
        pathRef3.addQuadCurve(to: CGPoint(x: 49.155, y: 108.659), control: CGPoint(x: 49.995, y: 109.819))
        pathRef3.addQuadCurve(to: CGPoint(x: 47.935, y: 106.039), control: CGPoint(x: 48.315, y: 107.499))
        pathRef3.addQuadCurve(to: CGPoint(x: 47.555, y: 103.219), control: CGPoint(x: 47.555, y: 104.579))
        pathRef3.closeSubpath()
        
        /*  Shape 4  */
        let pathRef4 = pathRef
        pathRef4.move(to: CGPoint(x: 76.1, y: 102.139))
        pathRef4.addLine(to: CGPoint(x: 68.1, y: 112.859))
        pathRef4.addLine(to: CGPoint(x: 71.22, y: 112.859))
        pathRef4.addLine(to: CGPoint(x: 77.58, y: 104.179))
        pathRef4.addLine(to: CGPoint(x: 84.06, y: 112.859))
        pathRef4.addLine(to: CGPoint(x: 87.26, y: 112.859))
        pathRef4.addLine(to: CGPoint(x: 79.22, y: 102.099))
        pathRef4.addLine(to: CGPoint(x: 86.66, y: 92.219))
        pathRef4.addLine(to: CGPoint(x: 83.5, y: 92.219))
        pathRef4.addLine(to: CGPoint(x: 77.74, y: 100.059))
        pathRef4.addLine(to: CGPoint(x: 71.86, y: 92.219))
        pathRef4.addLine(to: CGPoint(x: 68.7, y: 92.219))
        pathRef4.closeSubpath()
        
        /*  Shape 5  */
        let pathRef5 = pathRef
        pathRef5.move(to: CGPoint(x: 96.325, y: 92.579))
        pathRef5.addLine(to: CGPoint(x: 96.325, y: 86.379))
        pathRef5.addLine(to: CGPoint(x: 93.805, y: 86.379))
        pathRef5.addLine(to: CGPoint(x: 93.805, y: 92.579))
        pathRef5.addLine(to: CGPoint(x: 90.205, y: 92.579))
        pathRef5.addLine(to: CGPoint(x: 90.205, y: 94.699))
        pathRef5.addLine(to: CGPoint(x: 93.805, y: 94.699))
        pathRef5.addLine(to: CGPoint(x: 93.805, y: 108.819))
        pathRef5.addQuadCurve(to: CGPoint(x: 94.765, y: 112.439), control: CGPoint(x: 93.765, y: 111.459))
        pathRef5.addQuadCurve(to: CGPoint(x: 98.285, y: 113.419), control: CGPoint(x: 95.765, y: 113.419))
        pathRef5.addQuadCurve(to: CGPoint(x: 99.405, y: 113.379), control: CGPoint(x: 98.845, y: 113.419))
        pathRef5.addQuadCurve(to: CGPoint(x: 100.525, y: 113.339), control: CGPoint(x: 99.965, y: 113.339))
        pathRef5.addLine(to: CGPoint(x: 100.525, y: 111.219))
        pathRef5.addQuadCurve(to: CGPoint(x: 98.365, y: 111.339), control: CGPoint(x: 99.445, y: 111.339))
        pathRef5.addQuadCurve(to: CGPoint(x: 96.665, y: 110.559), control: CGPoint(x: 97.005, y: 111.259))
        pathRef5.addQuadCurve(to: CGPoint(x: 96.325, y: 108.619), control: CGPoint(x: 96.325, y: 109.859))
        pathRef5.addLine(to: CGPoint(x: 96.325, y: 94.699))
        pathRef5.addLine(to: CGPoint(x: 100.525, y: 94.699))
        pathRef5.addLine(to: CGPoint(x: 100.525, y: 92.579))
        pathRef5.closeSubpath()
        
        designSize = CGSize(width: 128, height: 128)
        path = pathRef as CGPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 44, height: 44))
        pathLineWidth = 0.0
        pathStrokeColor = nil
        pathFillColor = UIColor.white
    }
}
