//
//  DismissButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

@IBDesignable public class DismissButton: PathBasedButton {

    // MARK: - Override Path Based Button
    
    public override func configureButton() {
        
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 98.825, y: 23.518))
        pathRef.addLine(to: CGPoint(x: 104.482, y: 29.175))
        pathRef.addLine(to: CGPoint(x: 69.657, y: 64))
        pathRef.addLine(to: CGPoint(x: 104.482, y: 98.825))
        pathRef.addLine(to: CGPoint(x: 98.825, y: 104.482))
        pathRef.addLine(to: CGPoint(x: 64, y: 69.657))
        pathRef.addLine(to: CGPoint(x: 29.175, y: 104.482))
        pathRef.addLine(to: CGPoint(x: 23.518, y: 98.825))
        pathRef.addLine(to: CGPoint(x: 58.343, y: 64))
        pathRef.addLine(to: CGPoint(x: 23.518, y: 29.175))
        pathRef.addLine(to: CGPoint(x: 29.175, y: 23.518))
        pathRef.addLine(to: CGPoint(x: 64, y: 58.343))
        pathRef.addLine(to: CGPoint(x: 98.825, y: 23.518))
        pathRef.closeSubpath()
        
        designSize = CGSize(width: 128, height: 128)
        path = pathRef as CGPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 36, height: 36))
        pathLineWidth = 0.0
        pathStrokeColor = nil
        pathFillColor = UIColor.white
    }

}
