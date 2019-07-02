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
@IBDesignable public class StrokeTool: ToolButton {
    
    override var pathStrokeColor: UIColor? {
        get {
            return super.pathFillColor
        }
        set(newVal) {
            guard newVal != nil else { return }
            super.pathFillColor = newVal
        }
    }
    
    override var pathFillColor: UIColor? {
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
        pathStrokeColor = UIColor.black
        pathFillColor = UIColor.black
        pathLineWidth = 0.5
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        path = pathRef as CGPath
        cornerRadius = 20.0
        backgroundColor = UIColor(white: 0.0, alpha: 0.2)
    }
}

/**
    Button with a rectangle path to hint drawing of a rectangle
 */
@IBDesignable public class RectangleTool: ToolButton {
    
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        
        /*  Shape   */
        let bezierPath = UIBezierPath(rect: CGRect(x: 8, y: 12, width: 24, height: 16))
        
        toolType = RectangleShape.self
        designSize = CGSize(width: 40.0, height: 40.0)
        pathLineWidth = 2.0
        pathStrokeColor = nil
        pathFillColor = nil
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        path = bezierPath.cgPath
    }
}

/**
 Button with an oval path to hint drawing of an oval
 */
@IBDesignable public class OvalTool: ToolButton {
    
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        
        /*  Shape   */
        let bezierPath = UIBezierPath(ovalIn: CGRect(x: 5, y: 7, width: 30, height: 26))
        
        toolType = OvalShape.self
        designSize = CGSize(width: 40.0, height: 40.0)
        pathLineWidth = 2.0
        pathStrokeColor = nil
        pathFillColor = nil
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        path = bezierPath.cgPath
    }
}

/**
    Button with a line to hint drawing of a line
*/
@IBDesignable public class LineTool: ToolButton {
    
    override public var pathStrokeColor: UIColor? {
        didSet {
            if pathStrokeColor == nil {
                pathStrokeColor = UIColor.black
            }
        }
    }
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        
        /*  Shape   */
        let mutablePath = CGMutablePath()
        mutablePath.move(to: CGPoint(x: 5, y:20))
        mutablePath.addLine(to: CGPoint(x:35, y:20))
        
        toolType = LineShape.self
        designSize = CGSize(width: 40.0, height: 40.0)
        pathLineWidth = 2.0
        pathStrokeColor = UIColor.black
        pathFillColor = nil
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        path = mutablePath as CGPath
    }
}

/**
    Button with an arrow referencing the forward arrow tool
*/
@IBDesignable public class ForwardArrowTool : ToolButton {
    
    override public var pathStrokeColor: UIColor? {
        didSet {
            if pathStrokeColor == nil {
                pathStrokeColor = UIColor.black
            }
        }
    }
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 15.625, y: 64.375))
        pathRef.addLine(to: CGPoint(x: 112.375, y: 64.375))

        // Arrow Head
        pathRef.move(to: CGPoint(x: 98.165, y: 49.79))
        pathRef.addLine(to: CGPoint(x: 112.375, y: 64))
        pathRef.addLine(to: CGPoint(x: 98.165, y: 78.21))

        
        toolType = ArrowShapeForward.self
        designSize = CGSize(width: 128.0, height: 128.0)
        pathLineWidth = 4.0
        pathStrokeColor = UIColor.black
        pathFillColor = nil
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        path = pathRef as CGPath
    }
}

/**
    Button with an arrow referencing the forward arrow tool
 */
@IBDesignable public class BackwardArrowTool : ToolButton {
    
    override public var pathStrokeColor: UIColor? {
        didSet {
            if pathStrokeColor == nil {
                pathStrokeColor = UIColor.black
            }
        }
    }
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
        
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 15.625, y: 64.375))
        pathRef.addLine(to: CGPoint(x: 112.375, y: 64.375))
        
        // Arrow Head
        pathRef.move(to: CGPoint(x: 29.835, y: 78.585))
        pathRef.addLine(to: CGPoint(x: 15.625, y: 64.375))
        pathRef.addLine(to: CGPoint(x: 29.835, y: 50.165))

        toolType = ArrowShapeBackward.self
        designSize = CGSize(width: 128.0, height: 128.0)
        pathLineWidth = 4.0
        pathStrokeColor = UIColor.black
        pathFillColor = nil
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        path = pathRef as CGPath
    }
}

/**
    Button with a letter referencing to the text tool
*/
@IBDesignable public class TextTool : ToolButton {
    
    // MARK: - Override PathBasedButton
    
    override public func configureButton() {
    
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 58.348, y: 49.096))
        pathRef.addLine(to: CGPoint(x: 58.348, y: 91))
        pathRef.addLine(to: CGPoint(x: 69.652, y: 91))
        pathRef.addLine(to: CGPoint(x: 69.652, y: 49.096))
        pathRef.addLine(to: CGPoint(x: 85.06, y: 49.096))
        pathRef.addLine(to: CGPoint(x: 85.06, y: 39.592))
        pathRef.addLine(to: CGPoint(x: 42.94, y: 39.592))
        pathRef.addLine(to: CGPoint(x: 42.94, y: 49.096))
        pathRef.closeSubpath()
        
        toolType = TextShape.self
        designSize = CGSize(width: 128.0, height: 128.0)
        pathLineWidth = 4.0
        pathStrokeColor = UIColor.black
        pathFillColor = UIColor.black
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        path = pathRef as CGPath
    }
}
