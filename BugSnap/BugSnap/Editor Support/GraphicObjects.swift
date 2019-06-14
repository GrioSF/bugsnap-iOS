//
//  GraphicObjects.swift
//  BugSnap
//  Common Definitions
//
//  Created by Héctor García Peña on 6/12/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import UIKit

/**
    The current graphic properties applied to a graphic context
*/
public struct GraphicProperties {

    /// The stroke color
    var strokeColor : UIColor? = UIColor.black
    
    /// The line width
    var lineWidth : CGFloat? = 2.0
    
    /// The fill color if we're using a closed path
    var fillColor : UIColor? = nil
    
}

/**
    Representation of a stroke.
 */
public class Stroke : NSObject {
    
    /// The enclosing frame for the stroke
    var enclosingFrame : CGRect {
        return CGRect(x: topLeft.x, y: topLeft.y, width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)
    }
    
    /// The path used for the building the stroke
    var path : CGMutablePath? = nil
    
    // MARK: - Private Properties
    
    /// The top left corner
    private var topLeft = CGPoint.zero
    
    /// The bottom right corner
    private var bottomRight = CGPoint.zero
    
    
    /**
     Appends a point to the stroke and updates the frame for the stroke
     - Parameter point: The point to add to the stroke
     */
    func append( point : CGPoint) {
        path?.addLine(to: point)
        topLeft = CGPoint(x: min(topLeft.x,point.x), y: min(topLeft.y,point.y))
        bottomRight = CGPoint(x: max(bottomRight.x,point.x), y: max(bottomRight.y,point.y))
    }
    
    /**
     Initializes the stroke with a single point
     
     This method sets the origin of the frame to this starting point so we can compute easily the transform to enclose the whole stroke (and center it for further processing).
     
     - Note: The side effect of this method is that effectively clears the the points array since we're starting the stroke
     
     - Parameter point: The point to start the stroke.
     */
    func start( with point : CGPoint) {
        path = CGMutablePath()
        path?.move(to: point)
        topLeft = point
        bottomRight = CGPoint.zero
    }
}

/**
    Convenient extension to perform some operations over points
*/
public extension CGPoint {
    
    /**
        Converts this point to the new frame of reference with origin
        - Parameter origin: The new origin for this point
    */
    func convert( with origin : CGPoint ) -> CGPoint {
        return CGPoint(x: x - origin.x, y: y - origin.y)
    }
}

/**
    Extension of a cgcontext to apply our own graphic properties
*/
public extension CGContext {
    
    /**
        Applies the graphic properties to the context.
        - Parameter properties: The graphic properties for the context to do some drawing with such properties
    */
    func apply( properties : GraphicProperties ) {
        if let strokeColor = properties.strokeColor {
            setStrokeColor(strokeColor.cgColor)
        }
        if let fillColor = properties.fillColor {
            setFillColor(fillColor.cgColor)
        }
        if let lineWidth = properties.lineWidth {
            setLineWidth(lineWidth)
        }
    }
}
