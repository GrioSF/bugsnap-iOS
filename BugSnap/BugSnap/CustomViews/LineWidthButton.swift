//
//  LineWidthButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/14/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Button or view that showcases a line width configuration property.
*/
class LineWidthButton: PathBasedButton {

    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        let mutablePath = CGMutablePath()
        mutablePath.move(to: CGPoint(x: 5.0, y: 30.0))
        mutablePath.addLine(to: CGPoint(x: 55.0, y: 30.0))
        keepAspectRatio = false
        designSize = CGSize(width: 60.0, height: 60.0)
        path = mutablePath as CGPath
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 60))
        pathLineWidth = 1.0
        pathStrokeColor = UIColor.black
    }

}
