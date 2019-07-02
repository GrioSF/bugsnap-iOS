//
//  DrawToolButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

@IBDesignable public class DrawToolButton: ToolbarSelectableButton {

    // MARK: - Override Path Based Button
    
    public override func configureButton() {
    
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 37.375, y: 71.562))
        pathRef.addLine(to: CGPoint(x: 40.625, y: 51.562))
        pathRef.addLine(to: CGPoint(x: 78.25, y: 14.813))
        pathRef.addLine(to: CGPoint(x: 95.625, y: 32.562))
        pathRef.addLine(to: CGPoint(x: 58.25, y: 68.688))
        pathRef.addLine(to: CGPoint(x: 37.375, y: 71.562))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 70.875, y: 28.813))
        pathRef.addLine(to: CGPoint(x: 81.375, y: 39.312))
        pathRef.addLine(to: CGPoint(x: 89.375, y: 32.062))
        pathRef.addLine(to: CGPoint(x: 78.5, y: 21.063))
        pathRef.addLine(to: CGPoint(x: 70.875, y: 28.813))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 42.75, y: 67.062))
        pathRef.addLine(to: CGPoint(x: 56.92, y: 64.438))
        pathRef.addLine(to: CGPoint(x: 78.625, y: 43.062))
        pathRef.addLine(to: CGPoint(x: 67.125, y: 31.938))
        pathRef.addLine(to: CGPoint(x: 44.625, y: 53.812))
        pathRef.addLine(to: CGPoint(x: 42.75, y: 67.062))
        pathRef.closeSubpath()
        
        /*  Shape 2  */
        let pathRef2 = pathRef
        pathRef2.move(to: CGPoint(x: 15.3, y: 84.859))
        pathRef2.addLine(to: CGPoint(x: 15.3, y: 113.419))
        pathRef2.addLine(to: CGPoint(x: 25.18, y: 113.419))
        pathRef2.addQuadCurve(to: CGPoint(x: 35, y: 109.759), control: CGPoint(x: 31.7, y: 113.259))
        pathRef2.addQuadCurve(to: CGPoint(x: 38.3, y: 99.139), control: CGPoint(x: 38.3, y: 106.259))
        pathRef2.addQuadCurve(to: CGPoint(x: 35, y: 88.519), control: CGPoint(x: 38.3, y: 92.019))
        pathRef2.addQuadCurve(to: CGPoint(x: 25.18, y: 84.859), control: CGPoint(x: 31.7, y: 85.019))
        pathRef2.closeSubpath()
        pathRef2.move(to: CGPoint(x: 18.02, y: 111.099))
        pathRef2.addLine(to: CGPoint(x: 18.02, y: 87.179))
        pathRef2.addLine(to: CGPoint(x: 23.82, y: 87.179))
        pathRef2.addQuadCurve(to: CGPoint(x: 29.12, y: 87.839), control: CGPoint(x: 26.9, y: 87.179))
        pathRef2.addQuadCurve(to: CGPoint(x: 32.78, y: 89.939), control: CGPoint(x: 31.34, y: 88.499))
        pathRef2.addQuadCurve(to: CGPoint(x: 34.9, y: 93.659), control: CGPoint(x: 34.22, y: 91.379))
        pathRef2.addQuadCurve(to: CGPoint(x: 35.58, y: 99.139), control: CGPoint(x: 35.58, y: 95.939))
        pathRef2.addQuadCurve(to: CGPoint(x: 34.9, y: 104.619), control: CGPoint(x: 35.58, y: 102.339))
        pathRef2.addQuadCurve(to: CGPoint(x: 32.78, y: 108.339), control: CGPoint(x: 34.22, y: 106.899))
        pathRef2.addQuadCurve(to: CGPoint(x: 29.12, y: 110.439), control: CGPoint(x: 31.34, y: 109.779))
        pathRef2.addQuadCurve(to: CGPoint(x: 23.82, y: 111.099), control: CGPoint(x: 26.9, y: 111.099))
        pathRef2.closeSubpath()
        
        /*  Shape 3  */
        let pathRef3 = pathRef
        pathRef3.move(to: CGPoint(x: 46.72, y: 92.779))
        pathRef3.addLine(to: CGPoint(x: 46.72, y: 113.419))
        pathRef3.addLine(to: CGPoint(x: 49.24, y: 113.419))
        pathRef3.addLine(to: CGPoint(x: 49.24, y: 102.419))
        pathRef3.addQuadCurve(to: CGPoint(x: 49.8, y: 99.399), control: CGPoint(x: 49.24, y: 100.779))
        pathRef3.addQuadCurve(to: CGPoint(x: 51.38, y: 97.019), control: CGPoint(x: 50.36, y: 98.019))
        pathRef3.addQuadCurve(to: CGPoint(x: 53.8, y: 95.479), control: CGPoint(x: 52.4, y: 96.019))
        pathRef3.addQuadCurve(to: CGPoint(x: 56.92, y: 95.019), control: CGPoint(x: 55.2, y: 94.939))
        pathRef3.addLine(to: CGPoint(x: 56.92, y: 92.499))
        pathRef3.addQuadCurve(to: CGPoint(x: 52.1, y: 93.739), control: CGPoint(x: 54.12, y: 92.379))
        pathRef3.addQuadCurve(to: CGPoint(x: 49.12, y: 97.619), control: CGPoint(x: 50.08, y: 95.099))
        pathRef3.addLine(to: CGPoint(x: 49.04, y: 97.619))
        pathRef3.addLine(to: CGPoint(x: 49.04, y: 92.779))
        pathRef3.closeSubpath()
        
        /*  Shape 4  */
        let pathRef4 = pathRef
        pathRef4.move(to: CGPoint(x: 62.58, y: 98.539))
        pathRef4.addLine(to: CGPoint(x: 65.1, y: 98.539))
        pathRef4.addQuadCurve(to: CGPoint(x: 66.7, y: 94.879), control: CGPoint(x: 65.18, y: 96.019))
        pathRef4.addQuadCurve(to: CGPoint(x: 70.62, y: 93.739), control: CGPoint(x: 68.22, y: 93.739))
        pathRef4.addQuadCurve(to: CGPoint(x: 72.72, y: 93.919), control: CGPoint(x: 71.74, y: 93.739))
        pathRef4.addQuadCurve(to: CGPoint(x: 74.44, y: 94.579), control: CGPoint(x: 73.7, y: 94.099))
        pathRef4.addQuadCurve(to: CGPoint(x: 75.6, y: 95.879), control: CGPoint(x: 75.18, y: 95.059))
        pathRef4.addQuadCurve(to: CGPoint(x: 76.02, y: 97.979), control: CGPoint(x: 76.02, y: 96.699))
        pathRef4.addQuadCurve(to: CGPoint(x: 75.8, y: 99.339), control: CGPoint(x: 76.02, y: 98.819))
        pathRef4.addQuadCurve(to: CGPoint(x: 75.18, y: 100.159), control: CGPoint(x: 75.58, y: 99.859))
        pathRef4.addQuadCurve(to: CGPoint(x: 74.18, y: 100.579), control: CGPoint(x: 74.78, y: 100.459))
        pathRef4.addQuadCurve(to: CGPoint(x: 72.78, y: 100.779), control: CGPoint(x: 73.58, y: 100.699))
        pathRef4.addQuadCurve(to: CGPoint(x: 68.76, y: 101.279), control: CGPoint(x: 70.74, y: 101.019))
        pathRef4.addQuadCurve(to: CGPoint(x: 65.2, y: 102.179), control: CGPoint(x: 66.78, y: 101.539))
        pathRef4.addQuadCurve(to: CGPoint(x: 62.66, y: 104.039), control: CGPoint(x: 63.62, y: 102.819))
        pathRef4.addQuadCurve(to: CGPoint(x: 61.7, y: 107.419), control: CGPoint(x: 61.7, y: 105.259))
        pathRef4.addQuadCurve(to: CGPoint(x: 62.24, y: 110.119), control: CGPoint(x: 61.7, y: 108.979))
        pathRef4.addQuadCurve(to: CGPoint(x: 63.72, y: 111.999), control: CGPoint(x: 62.78, y: 111.259))
        pathRef4.addQuadCurve(to: CGPoint(x: 65.92, y: 113.079), control: CGPoint(x: 64.66, y: 112.739))
        pathRef4.addQuadCurve(to: CGPoint(x: 68.62, y: 113.419), control: CGPoint(x: 67.18, y: 113.419))
        pathRef4.addQuadCurve(to: CGPoint(x: 71.24, y: 113.139), control: CGPoint(x: 70.14, y: 113.419))
        pathRef4.addQuadCurve(to: CGPoint(x: 73.2, y: 112.339), control: CGPoint(x: 72.34, y: 112.859))
        pathRef4.addQuadCurve(to: CGPoint(x: 74.76, y: 111.039), control: CGPoint(x: 74.06, y: 111.819))
        pathRef4.addQuadCurve(to: CGPoint(x: 76.14, y: 109.259), control: CGPoint(x: 75.46, y: 110.259))
        pathRef4.addLine(to: CGPoint(x: 76.22, y: 109.259))
        pathRef4.addQuadCurve(to: CGPoint(x: 76.32, y: 110.719), control: CGPoint(x: 76.22, y: 110.059))
        pathRef4.addQuadCurve(to: CGPoint(x: 76.74, y: 111.859), control: CGPoint(x: 76.42, y: 111.379))
        pathRef4.addQuadCurve(to: CGPoint(x: 77.64, y: 112.599), control: CGPoint(x: 77.06, y: 112.339))
        pathRef4.addQuadCurve(to: CGPoint(x: 79.18, y: 112.859), control: CGPoint(x: 78.22, y: 112.859))
        pathRef4.addQuadCurve(to: CGPoint(x: 80.04, y: 112.819), control: CGPoint(x: 79.7, y: 112.859))
        pathRef4.addQuadCurve(to: CGPoint(x: 80.82, y: 112.699), control: CGPoint(x: 80.38, y: 112.779))
        pathRef4.addLine(to: CGPoint(x: 80.82, y: 110.579))
        pathRef4.addQuadCurve(to: CGPoint(x: 80.02, y: 110.739), control: CGPoint(x: 80.46, y: 110.739))
        pathRef4.addQuadCurve(to: CGPoint(x: 78.54, y: 109.219), control: CGPoint(x: 78.54, y: 110.739))
        pathRef4.addLine(to: CGPoint(x: 78.54, y: 98.259))
        pathRef4.addQuadCurve(to: CGPoint(x: 77.86, y: 94.879), control: CGPoint(x: 78.54, y: 96.179))
        pathRef4.addQuadCurve(to: CGPoint(x: 76.1, y: 92.859), control: CGPoint(x: 77.18, y: 93.579))
        pathRef4.addQuadCurve(to: CGPoint(x: 73.66, y: 91.879), control: CGPoint(x: 75.02, y: 92.139))
        pathRef4.addQuadCurve(to: CGPoint(x: 70.94, y: 91.619), control: CGPoint(x: 72.3, y: 91.619))
        pathRef4.addQuadCurve(to: CGPoint(x: 67.66, y: 92.019), control: CGPoint(x: 69.14, y: 91.619))
        pathRef4.addQuadCurve(to: CGPoint(x: 65.08, y: 93.259), control: CGPoint(x: 66.18, y: 92.419))
        pathRef4.addQuadCurve(to: CGPoint(x: 63.34, y: 95.419), control: CGPoint(x: 63.98, y: 94.099))
        pathRef4.addQuadCurve(to: CGPoint(x: 62.58, y: 98.539), control: CGPoint(x: 62.7, y: 96.739))
        pathRef4.closeSubpath()
        pathRef4.move(to: CGPoint(x: 76.02, y: 101.579))
        pathRef4.addLine(to: CGPoint(x: 76.02, y: 104.859))
        pathRef4.addQuadCurve(to: CGPoint(x: 75.44, y: 107.579), control: CGPoint(x: 76.02, y: 106.379))
        pathRef4.addQuadCurve(to: CGPoint(x: 73.88, y: 109.619), control: CGPoint(x: 74.86, y: 108.779))
        pathRef4.addQuadCurve(to: CGPoint(x: 71.58, y: 110.899), control: CGPoint(x: 72.9, y: 110.459))
        pathRef4.addQuadCurve(to: CGPoint(x: 68.82, y: 111.339), control: CGPoint(x: 70.26, y: 111.339))
        pathRef4.addQuadCurve(to: CGPoint(x: 67.1, y: 111.059), control: CGPoint(x: 67.94, y: 111.339))
        pathRef4.addQuadCurve(to: CGPoint(x: 65.62, y: 110.239), control: CGPoint(x: 66.26, y: 110.779))
        pathRef4.addQuadCurve(to: CGPoint(x: 64.6, y: 108.959), control: CGPoint(x: 64.98, y: 109.699))
        pathRef4.addQuadCurve(to: CGPoint(x: 64.22, y: 107.259), control: CGPoint(x: 64.22, y: 108.219))
        pathRef4.addQuadCurve(to: CGPoint(x: 65.12, y: 104.919), control: CGPoint(x: 64.22, y: 105.739))
        pathRef4.addQuadCurve(to: CGPoint(x: 67.42, y: 103.659), control: CGPoint(x: 66.02, y: 104.099))
        pathRef4.addQuadCurve(to: CGPoint(x: 70.52, y: 102.999), control: CGPoint(x: 68.82, y: 103.219))
        pathRef4.addQuadCurve(to: CGPoint(x: 73.82, y: 102.499), control: CGPoint(x: 72.22, y: 102.779))
        pathRef4.addQuadCurve(to: CGPoint(x: 75.02, y: 102.219), control: CGPoint(x: 74.34, y: 102.419))
        pathRef4.addQuadCurve(to: CGPoint(x: 75.94, y: 101.579), control: CGPoint(x: 75.7, y: 102.019))
        pathRef4.closeSubpath()
        
        
        /*  Shape 5  */
        let pathRef5 = pathRef
        pathRef5.move(to: CGPoint(x: 86.32, y: 92.779))
        pathRef5.addLine(to: CGPoint(x: 92.96, y: 113.419))
        pathRef5.addLine(to: CGPoint(x: 95.72, y: 113.419))
        pathRef5.addLine(to: CGPoint(x: 100.76, y: 96.059))
        pathRef5.addLine(to: CGPoint(x: 100.84, y: 96.059))
        pathRef5.addLine(to: CGPoint(x: 105.92, y: 113.419))
        pathRef5.addLine(to: CGPoint(x: 108.68, y: 113.419))
        pathRef5.addLine(to: CGPoint(x: 115.32, y: 92.779))
        pathRef5.addLine(to: CGPoint(x: 112.64, y: 92.779))
        pathRef5.addLine(to: CGPoint(x: 107.36, y: 110.459))
        pathRef5.addLine(to: CGPoint(x: 107.28, y: 110.459))
        pathRef5.addLine(to: CGPoint(x: 102.24, y: 92.779))
        pathRef5.addLine(to: CGPoint(x: 99.4, y: 92.779))
        pathRef5.addLine(to: CGPoint(x: 94.36, y: 110.459))
        pathRef5.addLine(to: CGPoint(x: 94.28, y: 110.459))
        pathRef5.addLine(to: CGPoint(x: 89, y: 92.779))
        pathRef5.closeSubpath()
        
        designSize = CGSize(width: 128, height: 128)
        path = pathRef as CGPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 44, height: 44))
        pathLineWidth = 0.0
        pathStrokeColor = nil
        pathFillColor = UIColor.white
    }

}
