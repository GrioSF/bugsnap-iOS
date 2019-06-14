//
//  ToolsButtons.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/13/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
 Button with a pencil path to symbolize a stroke button
 */
@IBDesignable class StrokeTool: ToolButton {
    
    override var pathStrokeColor: UIColor? {
        get {
            return nil
        }
        set(newVal) {
            
        }
    }
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        
        /*  Shape   */
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 41.8, y: 128))
        pathRef.addLine(to: CGPoint(x: 39.239, y: 128))
        pathRef.addLine(to: CGPoint(x: 39.239, y: 80.321))
        pathRef.addLine(to: CGPoint(x: 64, y: 18.4))
        pathRef.addLine(to: CGPoint(x: 88.761, y: 80.321))
        pathRef.addLine(to: CGPoint(x: 88.761, y: 128))
        pathRef.addLine(to: CGPoint(x: 86.2, y: 128))
        pathRef.addLine(to: CGPoint(x: 86.2, y: 118.663))
        pathRef.addLine(to: CGPoint(x: 86.2, y: 118.663))
        pathRef.addLine(to: CGPoint(x: 86.2, y: 80.502))
        pathRef.addLine(to: CGPoint(x: 75.562, y: 85.246))
        pathRef.addLine(to: CGPoint(x: 64.396, y: 80.502))
        pathRef.addLine(to: CGPoint(x: 53.957, y: 84.828))
        pathRef.addLine(to: CGPoint(x: 41.8, y: 80.502))
        pathRef.addLine(to: CGPoint(x: 41.8, y: 128))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 60.067, y: 33.298))
        pathRef.addLine(to: CGPoint(x: 42.267, y: 78.694))
        pathRef.addLine(to: CGPoint(x: 54.067, y: 82.311))
        pathRef.addLine(to: CGPoint(x: 64.396, y: 78.513))
        pathRef.addLine(to: CGPoint(x: 75.867, y: 83.396))
        pathRef.addLine(to: CGPoint(x: 86.2, y: 78.513))
        pathRef.addLine(to: CGPoint(x: 68.067, y: 33.479))
        pathRef.addLine(to: CGPoint(x: 60.067, y: 33.298))
        pathRef.closeSubpath()
        
        toolType = StrokeShape.self
        designSize = CGSize(width: 128.0, height: 128.0)
        pathStrokeColor = nil
        pathFillColor = UIColor.black
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        path = pathRef as CGPath
    }
}

/**
    Button with a pencil path to symbolize a stroke button
 */
@IBDesignable class RectangleTool: ToolButton {
    
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        
        /*  Shape   */
        let bezierPath = UIBezierPath(rect: CGRect(x: 10, y: 14, width: 20, height: 12))
        
        toolType = RectangleShape.self
        designSize = CGSize(width: 40.0, height: 40.0)
        pathStrokeColor = nil
        pathFillColor = UIColor.black
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        path = bezierPath.cgPath
    }
}

/**
 Button with a pencil path to symbolize a stroke button
 */
@IBDesignable class OvalTool: ToolButton {
    
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        
        /*  Shape   */
        let bezierPath = UIBezierPath(ovalIn: CGRect(x: 10, y: 12, width: 20, height: 16))
        
        toolType = OvalShape.self
        designSize = CGSize(width: 40.0, height: 40.0)
        pathStrokeColor = nil
        pathFillColor = UIColor.black
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        path = bezierPath.cgPath
    }
}
