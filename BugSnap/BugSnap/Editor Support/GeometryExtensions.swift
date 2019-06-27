//
//  GeometryExtensions.swift
//  Some extensions to some geometry based objects
//  BugSnap
//
//  Created by Héctor García Peña on 6/14/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

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
    
    /**
        Applies a rotation matrix with the given angle to the point
        - Parameter angle: The angle in radians to build the rotation matrix
    */
    func rotate( angle : Double ) -> CGPoint {
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)
        return CGPoint(x: cosAngle*Double(x) - sinAngle*Double(y), y: sinAngle*Double(x) + cosAngle*Double(y))
    }
    
    /**
        Applies the translation with the point given as parameter
        - Parameter point: The point to translate the current point.
    */
    func translate( to point: CGPoint ) -> CGPoint {
        return CGPoint(x: x+point.x, y: y+point.y)
    }
}

/**
    Convenient extension to have some computations
 */
public extension CGRect {
    
    /// The bottom right coordinate of this rectangle
    var bottomRight : CGPoint {
        return CGPoint(x: origin.x + size.width , y: origin.y + size.height )
    }
    
    /// Returns a rect with the same dimensions but anchored in the origin
    var originAnchoredRect : CGRect {
        return CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
}

/**
    Convenient extension to obtain information about a layer while is being manipulated
*/
public extension CALayer {
    
    /// The frame for the layer after applying the transform
    var transformedFrame : CGRect {
        var frame = CGRect(x: position.x - bounds.width * anchorPoint.x, y: position.y - bounds.height * anchorPoint.y, width: bounds.width, height: bounds.height)
        let affineTransform = CATransform3DGetAffineTransform(transform)
        frame = frame.applying(affineTransform)
        return frame
    }
}
