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
    Protocol to have a common way to notify some data between the view controller and the actual drawing commands
*/
protocol DrawableView {
    
    /// The graphic properties set to render the drawing. The implementor is responsible to draw itself if need or just
    /// using such properties from that point and on
    var graphicProperties : GraphicProperties! { get set }
    
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
