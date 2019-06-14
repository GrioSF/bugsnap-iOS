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
    
    
    // MARK: - Touches Management
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let toolType = currentToolType else { return }
        
        let point = touch.location(in: self)
        let tool = toolType.init()
        layer.addSublayer(tool)
        tool.bounds = layer.bounds
        tool.position = CGPoint(x: tool.bounds.width * 0.5, y: tool.bounds.height * 0.5)
        tool.graphicProperties = graphicProperties
        shapes.append(tool)
        tool.gestureBegan(point: point)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let tool =  shapes.last else { return }
        let point = touch.location(in: self)
        tool.gestureMoved(point: point)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            let tool =  shapes.last else { return }
        let point = touch.location(in: self)
        tool.gestureCancelled(point: point)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            let tool =  shapes.last else { return }
        let point = touch.location(in: self)
        
        // We save the frame before updating the layer
        let enclosingFrame = tool.enclosingFrame
        CATransaction.begin()
        CATransaction.disableActions()
        tool.removeFromSuperlayer()
        tool.gestureEnded(point: point)
        tool.bounds = CGRect(origin: CGPoint.zero, size: enclosingFrame.size)
        tool.position = CGPoint(x: enclosingFrame.midX, y: enclosingFrame.midY)
        layer.addSublayer(tool)
        CATransaction.commit()
    }

}
