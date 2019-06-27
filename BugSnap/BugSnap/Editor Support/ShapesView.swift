//
//  ShapesView.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/12/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import UIKit

/**
    View that holds shapes to be drawn. It uses a dynamic implementation through protocols and CALayer to present the user drawings.
*/
public class ShapesView: UIImageView {
    
    // MARK: - Properties
    
    /// The array of shapes this view is drawing
    var shapes = [ShapeTool]()
    
    /// The current tool to be used
    var currentToolType : ShapeToolType? = nil
    
    /// The current properties for the tool
    var graphicProperties = GraphicProperties()
    
    /// Whether this tool should be deselected at the end of the gesture
    var autoDeselect = true
    
    /// The handler when a tool input gesture has ended
    var onEndedGesture : ((Bool)->Void)? = nil
    
    /// The handler when the gesture has begun
    var onBeganGesture : (()->Void)? = nil
    
    /// The text to be captured
    var currentText : String? = "Text"
    
    /// Whether this view is dirty
    var isDirty : Bool {
        return shapes.count > 0
    }
    
    // MARK: - Private Properties
    
    /// Whether is scaling instead of translation
    private var scalingShape = false
    
    /// The current selected shape
    private weak var selectedShape : ShapeTool?
    
    /// The initial position for the gesture
    private var initialPoint = CGPoint.zero
    
    /// The original transformed frame for the selected shape
    private var shapeInitialFrame = CGRect.zero
    
    // MARK: - Exposed Methods
    
    /**
        Removes the last element from the layers stack if any.
        Returns true if there're more content on the layer stack
    */
    func undo() -> Bool {
        guard shapes.count > 0 else {
            return false
        }
        let layer = shapes.removeLast()
        layer.removeFromSuperlayer()
        return shapes.count > 0
    }
    
    // MARK: - Support for the container scroll view
    
    func touchesShouldBegin( _ touches: Set<UITouch>, with event: UIEvent?) -> Bool {
        
        // Deselect the selected shape
        selectedShape?.isSelected = false
        selectedShape = nil
        
        guard let touch = touches.first,
              touches.count == 1
            else { return  false }
        
        if currentToolType != nil {
            return true
        }
        let point = touch.location(in: self)
        
        for shape in shapes.reversed() {
            let frame = shape.frame
            let scaleFrame = CGRect(x: frame.bottomRight.x - 20.0, y: frame.bottomRight.y - 20.0, width: 40.0, height: 40.0)
            let isScale = scaleFrame.contains(point)
            
            // Check if we can select this shape
            if isScale || frame.contains(point) {
                return true
            }
        }
        
        
        return false
    }
    
    // MARK: - Touches Management
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first
               else { return }
        
        let point = touch.location(in: self)
        initialPoint = point
        scalingShape = false
        
        // Check if we must create a new shape or select it
        if !beginShapeCreation(point: point) {
            
            var found = false
            for shape in shapes.reversed() {
                let frame = shape.frame
                let scaleFrame = CGRect(x: frame.bottomRight.x - 20.0, y: frame.bottomRight.y - 20.0, width: 40.0, height: 40.0)
                let isScale = scaleFrame.contains(point)
                
                // Check if we can select this shape
                if isScale || frame.contains(point) {
                    selectedShape?.isSelected = false
                    shape.isSelected = true
                    selectedShape = shape
                    shapeInitialFrame = frame
                    found = true
                    scalingShape = isScale
                    (superview as? UIScrollView)?.isScrollEnabled = false
                    break
                }
                
            }
            if !found ,
                let shape = selectedShape {
                shape.isSelected = false
                selectedShape = nil
            }
        }
        
        
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first
               else { return }
        
        let point = touch.location(in: self)
        
        if let tool =  shapes.last,
            selectedShape == nil && currentToolType != nil {
            tool.gestureMoved(point: point)
            
        // we're moving the shape
        } else if selectedShape != nil{
            implementShapeTransform(point: point)
        }
        
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        if let tool =  shapes.last,
            selectedShape == nil  && currentToolType != nil{
            tool.gestureMoved(point: point)
            
            tool.gestureCancelled(point: point)
            
            currentToolType = autoDeselect ? nil : currentToolType
            onEndedGesture?(autoDeselect)
        } else if let shape = selectedShape {
            shape.transform = CATransform3DIdentity
        }
        
        (superview as? UIScrollView)?.isScrollEnabled = true
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let point = touch.location(in: self)
        
        if let tool =  shapes.last,
            selectedShape == nil  && currentToolType != nil{
            
            // We save the frame before updating the layer
            let enclosingFrame = tool.enclosingFrame
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            tool.removeFromSuperlayer()
            tool.gestureEnded(point: point)
            tool.bounds = CGRect(origin: CGPoint.zero, size: enclosingFrame.size)
            tool.anchorPoint = CGPoint.zero
            tool.position = CGPoint(x: enclosingFrame.origin.x, y: enclosingFrame.origin.y)
            layer.addSublayer(tool)
            CATransaction.commit()
            currentToolType = autoDeselect ? nil : currentToolType
            onEndedGesture?(autoDeselect)
        } else if selectedShape !=  nil {
            applyShapeTransform(point: point)
        }
        
        (superview as? UIScrollView)?.isScrollEnabled = true
        
    }
    
    // MARK: - Shape creation support
    
    private func beginShapeCreation( point : CGPoint ) -> Bool {
        guard let toolType = currentToolType else { return false }
        
        let tool = toolType.init()
        layer.addSublayer(tool)
        tool.bounds = layer.bounds
        tool.position = CGPoint(x: tool.bounds.width * 0.5, y: tool.bounds.height * 0.5)
        tool.graphicProperties = graphicProperties
        shapes.append(tool)
        
        // Support for text tool
        if var textTool = tool as? TextShapeProtocol {
            textTool.text = currentText
            currentText = nil
        }
        
        tool.gestureBegan(point: point)
        onBeganGesture?()
        selectedShape?.isSelected = false
        selectedShape = nil
        
        (superview as? UIScrollView)?.isScrollEnabled = false
        
        return true
    }

    private func implementShapeTransform( point : CGPoint) {
        if let shape = selectedShape {
            
            let translation = point.convert(with: initialPoint)
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            if scalingShape {
                let initialDimension = shapeInitialFrame.size
                let scale = CGSize(width: (point.x - shapeInitialFrame.origin.x)/initialDimension.width,
                                   height: (point.y - shapeInitialFrame.origin.y)/initialDimension.height)
                shape.transform = CATransform3DMakeScale(scale.width, scale.height, 1.0)
            } else {
                shape.transform = CATransform3DMakeTranslation(translation.x, translation.y, 0)
            }
            CATransaction.commit()
        }
    }
    
    private func applyShapeTransform( point : CGPoint )  {
        if let shape = selectedShape {
            
            /// The transform to use
            let translation = point.convert(with: initialPoint)
            
            if scalingShape {
                let initialDimension = shapeInitialFrame.size
                let scale = CGSize(width: (point.x - shapeInitialFrame.origin.x)/initialDimension.width,
                                   height: (point.y - shapeInitialFrame.origin.y)/initialDimension.height)
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                shape.isSelected = false
                shape.transform = CATransform3DIdentity
                shape.bounds = CGRect(x: 0.0, y: 0.0, width: shapeInitialFrame.width * scale.width, height: shapeInitialFrame.height * scale.height)
                shape.implementScale(scale: scale)
                shape.isSelected = true
                CATransaction.commit()
                
            } else {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                shape.transform = CATransform3DIdentity
                shape.position = CGPoint(x: shape.position.x + translation.x, y: shape.position.y + translation.y)
                CATransaction.commit()
            }
        }
    }
}
