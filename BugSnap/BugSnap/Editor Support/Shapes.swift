//
//  Shapes.swift
//  BugSnap
//  Definition for shapes to be drawn into the markup editor. Contains the base protocol and some basic shapes
//
//  Created by Héctor García Peña on 6/13/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
    Protocol for managing the touch interface to setup a shape.
*/
public protocol ShapeGestureHandler : NSObject {

    /// The initial point when gesture has started. This is useful in a lot of situations when draggin in the UI
    var initialPoint : CGPoint { get set }
    
    /**
        Method to be called when the gesture began. The method should set the initial point in order to be consistent with the rest
        of the methods.
        - Parameter point: The position in the current editing view coordinates where the gesture took place.
    */
    func gestureBegan( point : CGPoint )
    
    /**
        Method to be called *each time* a moved event is generated. Be careful with the operations performed here.
        - Parameter point: The current position where the event is taking place
    */
    func gestureMoved( point : CGPoint )
    
    /**
        Method to be called when the gesture has been cancelled by the system (perhaps an call, change the app to the background, etc).
        - Parameter point: The position where the event took place when being cancelled
    */
    func gestureCancelled( point : CGPoint )
    
    /**
        Method to be called when the gesture has ended (perhaps the user lift his finger).
        - Parameter point: The last position where the event took place
    */
    func gestureEnded( point : CGPoint )
}


/**
 Protocol for all the drawings that may be added to an image as markup
 */
public protocol ShapeProtocol : NSObject {
    
    /// The frame tha encloses the drawing.
    var enclosingFrame : CGRect { get set }
    
    /// The rotation for the current shape.
    var rotation : CGFloat? { get set }
    
    /// The translation for the current shape.
    var translation : CGPoint? { get set }
    
    /// The graphic properties for rendering the object
    var graphicProperties : GraphicProperties! { get set }
    
    /// The implementation for the gesture handler
    var handler : ShapeGestureHandler? { get }
}

/**
    Protocol to be used on a shape based in a path so we can figure out which path is to be represented in a shape layer
*/
public protocol ShapePathAdapter : ShapeGestureHandler {
    
    /**
        Starts the path with the point
        - Parameter point: The starting point for the path
    */
    func startPath( point: CGPoint )
    
    /**
        Updates the path with the new point added to the gesture
        - Parameter point: The new point added in the gesture
    */
    func updatePath( point: CGPoint )
    
    /**
        Returns the updated frame after adding a new point to the path adapter
        - Parameter point: The new point found in the gesture
    */
    func updatedFrame( point : CGPoint) -> CGRect
    
    /**
        Normalizes the resulting path after the drawing operation finished to shrink the shape layer into the minimum expression. This method should use the updatedFrame.
        Once the path is normalized the shape layer will be shrink to the updated frame.
    */
    func normalizePath()
}

/// A convenience alias for the shape tool
typealias ShapeTool = CAShapeLayer&ShapeProtocol&ShapeGestureHandler

/// The type for a shape tool
typealias ShapeToolType = ShapeTool.Type

/**
    Implementation of an abstract shape. This class implements the shape protocol with the limitation that it doesn't draw anything, based on a CAShapeLayer. This solution has the advantage of using a path for drawing different kind of shapes.
*/
public class Shape : CAShapeLayer, ShapeProtocol, ShapePathAdapter {
    
    
    // MARK: - ShapeGestureHandler Properties
    
    public var initialPoint = CGPoint.zero
    
    
    // MARK: - ShapeProtocol Implementation
    
    public var enclosingFrame: CGRect = CGRect.zero
    
    public var rotation: CGFloat? = nil {
        didSet {
            implementTransform()
        }
    }
    
    public var translation: CGPoint? = nil {
        didSet {
            implementTransform()
        }
    }
    
    public var graphicProperties: GraphicProperties! = GraphicProperties() {
        didSet {
            fillColor = graphicProperties.fillColor?.cgColor
            strokeColor = graphicProperties.strokeColor?.cgColor
            lineWidth = graphicProperties.lineWidth ?? 0.0
            setNeedsDisplay()
        }
    }
    
    public var handler: ShapeGestureHandler? { return self}
    
    // MARK: - ShapeGestureHandler methods
    
    public func gestureBegan(point: CGPoint) {
        initialPoint = point
        startPath(point: initialPoint)
    }
    
    public func gestureMoved(point: CGPoint) {
        updatePath( point: point)
        enclosingFrame = updatedFrame(point: point)
    }
    
    public func gestureCancelled(point: CGPoint) {
        updatePath(point: point)
        enclosingFrame = updatedFrame(point: point)
        normalizePath()
    }
    
    public func gestureEnded(point: CGPoint) {
        updatePath(point: point)
        enclosingFrame = updatedFrame(point: point)
        normalizePath()
    }
    
    public func startPath(point: CGPoint) {
        
    }
    
    public func updatePath( point : CGPoint ) {
    }
    
    public func normalizePath() {
    }
    
    public func updatedFrame(point: CGPoint) -> CGRect {
        let rect = CGRect(x: min(initialPoint.x,point.x), y: min(initialPoint.y,point.y), width: abs(point.x-initialPoint.x), height: abs(point.y-initialPoint.y))
        return rect
    }
    
    // MARK: - Support
    
    private func implementTransform() {
        var transform  : CATransform3D? = nil
        
        if rotation != nil {
           transform = CATransform3DMakeRotation(rotation!.radians, 0, 0, 1.0)
        }
        
        if translation != nil {
            let translationTransform = CATransform3DMakeTranslation(translation!.x, translation!.y, 0.0)
            if transform != nil {
                transform = CATransform3DConcat(transform!, translationTransform)
            } else {
                transform = translationTransform
            }
        }
        
        if transform != nil {
            self.transform = transform!
        }
    }
}

/**
    Shape for an arbitrary path. It uses lines to connect each point in the path. It's supposed to be an open path.
*/
public class StrokeShape : Shape {
    
    // MARK: - Properties
    
    /// The points building the stroke
    var points = [CGPoint]()
    
    /// The stroke that will compose the path
    var stroke = Stroke()
    
    // MARK: - Overrides to build the shape
    
    override public func startPath(point: CGPoint) {
        points.removeAll()
        stroke.start(with: point)
    }
    
    override public func updatePath(point: CGPoint) {
        stroke.append(point: point)
        points.append(point)
        path = stroke.path as CGPath?
    }
    
    override public func updatedFrame(point: CGPoint) -> CGRect {
        return stroke.enclosingFrame
    }
    
    override public func normalizePath() {
        let frame = enclosingFrame
        let pointsCopy = points
    
        startPath(point: pointsCopy.first!.convert(with: frame.origin))
        for point in pointsCopy[1...] {
            let converted = point.convert(with: frame.origin)
            stroke.append(point: converted)
            points.append(converted)
        }
        path = stroke.path as CGPath?
        enclosingFrame = CGRect(x: 0, y: 0, width: enclosingFrame.width, height: enclosingFrame.height)
    }
}

/**
    Shape for a rectangle path.
*/
public class RectangleShape : Shape {
    
    override public func updatePath(point: CGPoint) {
        let frame = updatedFrame(point: point)
        path = UIBezierPath(rect: frame).cgPath
    }
    
    override public func normalizePath() {
        enclosingFrame = CGRect(x: 0, y: 0, width: enclosingFrame.width, height: enclosingFrame.height)
        path = UIBezierPath(rect: enclosingFrame ).cgPath
    }
    
}

/**
    Shape for an oval path.
*/
public class OvalShape : Shape {
    
    override public func updatePath(point: CGPoint) {
        let frame = updatedFrame(point: point)
        path = UIBezierPath(ovalIn: frame).cgPath
    }
    
    override public func normalizePath() {
        enclosingFrame = CGRect(x: 0, y: 0, width: enclosingFrame.width, height: enclosingFrame.height)
        path = UIBezierPath(ovalIn: enclosingFrame).cgPath
    }
}

