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
    var autoDeselect = false
    
    /// The handler when a tool input gesture has ended
    var onEndedGesture : ((Bool)->Void)? = nil
    
    /// The handler when the gesture has begun
    var onBeganGesture : (()->Void)? = nil
    
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
    
    /// The number of movement events
    private var numberMovedEvents = 0
    
    /// The original transformed frame for the selected shape
    private var shapeInitialFrame = CGRect.zero
    
    /// the last valid scale
    private var lastValidScale = CGSize.zero
    
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
    
    /**
        Deletes the selected shape and removes it from the shapes array
    */
    func deleteSelectedShape() {
        guard let shape = selectedShape else { return }
        selectedShape = nil
        shape.removeFromSuperlayer()
        shapes.removeAll {
            return $0 === shape
        }
    }
    
    // MARK: - Support for the container scroll view
    
    func touchesShouldBegin( _ touches: Set<UITouch>, with event: UIEvent?) -> Bool {
        
        if let _ = selectedShape as? TextShapeProtocol {
            return true
        }
        
        guard let touch = touches.first
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
        numberMovedEvents = 0
        
        // Check the current type of shape and the last one on the queue
        if let shape = shapes.last,
           let toolType = currentToolType,
            shape.isComposed && shape.isKind(of: toolType) && selectedShape == nil {
            selectedShape?.isSelected = false
            beginShapeCreation(point: point)
            return
        }
          
        /// Now proceed to find a selection
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
                lastValidScale = CGSize.zero
                found = true
                scalingShape = isScale
                break
            }
            
        }
        
        if !found {
            if let shape = selectedShape {
                shape.isSelected = false
                selectedShape = nil
            }
            beginShapeCreation(point: point)
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first
               else { return }
        
        let point = touch.location(in: self)
        numberMovedEvents += 1
        
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
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let point = touch.location(in: self)
        
        if let tool =  shapes.last,
            selectedShape == nil  && currentToolType != nil {
            
            // Remove the potential shape, and try to select a shape
            guard ((initialPoint.distance(to: point) > 10.0 || numberMovedEvents > 2) &&
                !(tool is TextShapeProtocol) ) ||
                (tool is TextShapeProtocol) else {
                
                tool.removeFromSuperlayer()
                shapes.removeLast()
                for shape in shapes.reversed() {
                    let frame = shape.frame
                    if frame.contains(point) {
                        selectedShape = shape
                        shape.isSelected = true
                        scalingShape = false
                        break
                    }
                }
                return
            }
            
            // We save the frame before updating the layer
            let enclosingFrame = tool.enclosingFrame
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            tool.gestureEnded(point: point)
            tool.bounds = CGRect(origin: CGPoint.zero, size: enclosingFrame.size)
            tool.anchorPoint = CGPoint.zero
            tool.position = CGPoint(x: enclosingFrame.origin.x, y: enclosingFrame.origin.y)
            CATransaction.commit()
            currentToolType = autoDeselect ? nil : currentToolType
            onEndedGesture?(autoDeselect)
        } else if selectedShape !=  nil {
            applyShapeTransform(point: point)
            
            if initialPoint.distance(to: point) < 10.0,
               let textView = selectedShape as? TextShapeProtocol {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    textView.becomeFirstResponder()
                }
            }
            
        }
        
    }
    
    // MARK: - Shape creation support
    
    private func beginShapeCreation( point : CGPoint )  {
        guard let toolType = currentToolType else { return  }
        
        
        let tool = toolType.init()
        layer.addSublayer(tool)
        tool.bounds = layer.bounds
        tool.position = CGPoint(x: tool.bounds.width * 0.5, y: tool.bounds.height * 0.5)
        tool.graphicProperties = graphicProperties
        shapes.append(tool)
        tool.gestureBegan(point: point)
        onBeganGesture?()
        selectedShape?.isSelected = false
        selectedShape = nil
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
                if scale.width > 0.0 && scale.height > 0.0 {
                    shape.transform = CATransform3DMakeScale(scale.width, scale.height, 1.0)
                    lastValidScale = scale
                }
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
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            if scalingShape {
                let initialDimension = shapeInitialFrame.size
                var scale = CGSize(width: (point.x - shapeInitialFrame.origin.x)/initialDimension.width,
                                   height: (point.y - shapeInitialFrame.origin.y)/initialDimension.height)
                
                if scale.width <= 0.0 || scale.height <= 0.0 {
                    scale = lastValidScale
                }

                shape.isSelected = false
                shape.transform = CATransform3DIdentity
                if scale.width > 0.0 && scale.height > 0.0 {
                    shape.bounds = CGRect(x: 0.0, y: 0.0, width: shapeInitialFrame.width * scale.width, height: shapeInitialFrame.height * scale.height)
                    shape.implementScale(scale: scale)
                }
                shape.isSelected = true
            } else {
                shape.transform = CATransform3DIdentity
                shape.position = CGPoint(x: shape.position.x + translation.x, y: shape.position.y + translation.y)
                
            }
            CATransaction.commit()
        }
    }
}
