//
//  StrokeView.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/12/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Representation of a stroke.
*/
public class Stroke : NSObject {
    
    
    /// The points that represent the stroke
    var points = [CGPoint]()
    
    /// The stroke color
    var properties : GraphicProperties!
    
    // MARK: - Methods
    
    func drawInContext( context : CGContext ) {
        
        let path = CGMutablePath()
        path.move(to: points.first!)
        
        for point in points[1...] {
            path.addLine(to: point)
        }
        context.saveGState()
        context.apply(properties: properties)
        context.addPath(path)
        context.strokePath()
        context.restoreGState()
    }
}

/**
    View to represent strokes in an annotation
*/
public class StrokeView: UIView,DrawableView {
    
    // MARK: - Properties
    
    /// The array of strokes
    var strokes = [Stroke]()
    
    /// The current graphic properties to initiate a stroke
    var graphicProperties : GraphicProperties!
    
    // MARK: - Private Properties
    
    // MARK: - Drawing
    
    override public func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        for stroke in strokes {
            stroke.drawInContext(context: context)
        }
    }
    
    // MARK: - Touches Management
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first  else { return }
        let point = touch.location(in: self)
        let stroke = Stroke()
        stroke.properties = graphicProperties
        stroke.points.append(point)
        strokes.append(stroke)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let stroke = strokes.last else { return }
        
        let point = touch.location(in: self)
        stroke.points.append(point)
        strokes.append(stroke)
        setNeedsDisplay()
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            let stroke = strokes.last else { return }
        let point = touch.location(in: self)
        stroke.points.append(point)
        strokes.append(stroke)
        setNeedsDisplay()
    }

}
