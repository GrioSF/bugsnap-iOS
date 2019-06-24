//
//  LineShapes.swift
//  BugSnap
//
//  This file contains the implementations of LineBased Shapes (including the base class, line shape)
//  Created by Héctor García Peña on 6/17/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation
import UIKit


/**
 Shape for a line path
 */
public class LineShape : Shape {
    
    /// The last point for the line shape
    var lastPoint : CGPoint = CGPoint.zero
    
    override public func updatePath(point: CGPoint) {
        let mutablePath = CGMutablePath()
        mutablePath.move(to: initialPoint)
        mutablePath.addLine(to: point)
        path = mutablePath as CGPath
        lastPoint = point
    }
    
    override public func normalizePath() {
        let frame = enclosingFrame
        let mutablePath = CGMutablePath()
        mutablePath.move(to: initialPoint.convert(with: frame.origin))
        mutablePath.addLine(to: lastPoint.convert(with: frame.origin))
        path = mutablePath as CGPath
        enclosingFrame = enclosingFrame.originAnchoredRect
    }
}

/**
 Shape for a path that will add itself at one of the ends of the line. This will be useful for extending with more shapes like this
 */
public class AbstractLineBasedShaped : LineShape {
    
    // MARK: - Override Line Shape
    
    override public func updatePath(point: CGPoint) {
        super.updatePath(point: point)
        addPathToLine( start: initialPoint, end: lastPoint)
    }
    
    override public func normalizePath() {
        let frame = enclosingFrame
        super.normalizePath()
        addPathToLine(start: initialPoint.convert(with: frame.origin), end: lastPoint.convert(with: frame.origin))
    }
    
    // MARK: - Overridable methods
    
    /**
     This method will add a path at one end of the line.
     You can take advantage that LineShape uses a CGMutablePath and just add the extra instructions needed.
     The implementation doesn't do anything and it expects subclasses to implement the required path needed
     - Parameter start: The real start of the line path.
     - Parameter end: The end of the parent line path.
     */
    func addPathToLine( start : CGPoint , end : CGPoint ) {
        
    }
}

/**
    Base class for arrow shapes, that has some common properties (line the angle of the lines of the arrow head, and the length of such composing lines in the arrow head). The path is expected to be implemented in subclasses of this base class
 */
public class BaseArrowShape : AbstractLineBasedShaped {
    
    // MARK: - Customization of Arrow Shape
    
    /// The length for the arrow head line (each one of it)
    let arrowHeadLength = 10.0
    
    /// The angle at which the arrow head lines should be (defaults to 30.0 degrees). The value of this angle is expected in degrees.
    let arrowHeadLineAngle = 30.0
    
    
}

/**
    Shape for an arrow path, with the arrow head being drawn at the end of the line.
 */
public class ArrowShapeForward : BaseArrowShape {
    
    
    // MARK: - LineBasedShape Override
    
    public override func addPathToLine( start : CGPoint, end : CGPoint) {
        let v = CGPoint(x: end.x - start.x, y: end.y - start.y)
        let cosAngle = cos(arrowHeadLineAngle.radians)
        let sinAngle = sin(arrowHeadLineAngle.radians)
        let initialAngle = abs(v.x) > 0.0001 ? atan(v.y/v.x) : ((v.y > 0.0 ? -1.0 : +1.0 ) * .pi * 0.5)
        let angle = v.x > 0.0 ? initialAngle : (initialAngle + .pi)
        let startArrowHead = CGPoint(x: -arrowHeadLength*cosAngle, y: arrowHeadLength*sinAngle).rotate(angle: Double(angle)).translate(to: end)
        let endArrowHead = CGPoint(x: -arrowHeadLength*cosAngle, y: -arrowHeadLength*sinAngle).rotate(angle: Double(angle)).translate(to: end)
        let mutablePath = path as! CGMutablePath
        mutablePath.move(to: startArrowHead)
        mutablePath.addLine(to: end)
        mutablePath.addLine(to: endArrowHead)
        path = mutablePath as CGPath
    }
}

/**
    Shape for an arrow path, with the arrow head being drawn at the beginning of the line
 */
public class ArrowShapeBackward : BaseArrowShape {
    
    // MARK: - LineBasedShape Override
    
    public override func addPathToLine(start: CGPoint, end: CGPoint) {
        let v = CGPoint(x: end.x - start.x, y: end.y - start.y)
        let cosAngle = cos(arrowHeadLineAngle.radians)
        let sinAngle = sin(arrowHeadLineAngle.radians)
        let initialAngle = abs(v.x) > 0.0001 ? atan(v.y/v.x) : ((v.y > 0.0 ? -1.0 : +1.0 ) * .pi * 0.5)
        let angle = v.x > 0.0 ? initialAngle : (initialAngle + .pi)
        let startArrowHead = CGPoint(x: arrowHeadLength*cosAngle, y: arrowHeadLength*sinAngle).rotate(angle: Double(angle)).translate(to: start)
        let endArrowHead = CGPoint(x: arrowHeadLength*cosAngle, y: -arrowHeadLength*sinAngle).rotate(angle: Double(angle)).translate(to: start)
        let mutablePath = path as! CGMutablePath
        mutablePath.move(to: startArrowHead)
        mutablePath.addLine(to: start)
        mutablePath.addLine(to: endArrowHead)
        path = mutablePath as CGPath
    }
}
