//
//  TextShape.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/17/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Protocol to define the common point for setting the text in a text shape
*/
protocol TextShapeProtocol {
    
    /// The text as input for the shape
    var text : String? { get set }
}

/**
    Implementation of a text layer for drawing it as a shape
*/
public class TextShape: CALayer, ShapeProtocol&ShapeGestureHandler&TextShapeProtocol {
    
    
    // MARK: - For the text
    
    /// The text layer that will render the text
    private var textLayer = CATextLayer()
    
    /// The actual text that will be rendered
    public var text : String? = nil
    
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
            textLayer.foregroundColor = graphicProperties.fillColor?.cgColor ?? UIColor.black.cgColor
            textLayer.alignmentMode = .left
            textLayer.truncationMode = .none
            textLayer.font = CGFont(UIFont.systemFont(ofSize: 30.0, weight: .bold).fontName as NSString)
            textLayer.fontSize = 30.0
            textLayer.isWrapped = true
            let newActions = [String : CAAction]()
            textLayer.actions = newActions
            actions = newActions
            
            setNeedsDisplay()
        }
    }
    
    public var handler: ShapeGestureHandler? { return self}
    
    // MARK: - ShapeGestureHandler methods
    
    public func gestureBegan(point: CGPoint) {
        initialPoint = point
    }
    
    public func gestureMoved(point: CGPoint) {
        enclosingFrame = updatedFrame(point: point)
        if textLayer.superlayer == nil {
            addSublayer(textLayer)
            textLayer.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
            textLayer.borderColor = UIColor.blue.withAlphaComponent(0.2).cgColor
            textLayer.borderWidth = 2.0
            textLayer.string = text as NSString?
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textLayer.bounds = CGRect(origin: CGPoint.zero, size: enclosingFrame.size)
        textLayer.position = CGPoint(x: enclosingFrame.midX, y: enclosingFrame.midY)
        CATransaction.commit()
        
    }
    
    public func gestureCancelled(point: CGPoint) {
        endDragging( point:point )
    }
    
    public func gestureEnded(point: CGPoint) {
        endDragging( point: point)
    }
    

    
    public func updatedFrame(point: CGPoint) -> CGRect {
        let rect = CGRect(x: min(initialPoint.x,point.x), y: min(initialPoint.y,point.y), width: abs(point.x-initialPoint.x), height: abs(point.y-initialPoint.y))
        return rect
    }
    
    // MARK: - Support
    
    private func endDragging(point : CGPoint) {
        enclosingFrame = updatedFrame(point: point).originAnchoredRect
        textLayer.frame = enclosingFrame
        textLayer.backgroundColor = nil
        textLayer.borderColor = nil
        textLayer.borderWidth = 0.0
    }
    
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
