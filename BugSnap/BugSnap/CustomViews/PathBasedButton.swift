//
//  PathBasedButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/12/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import UIKit

/**
    This is a path that uses a CAShapeLayer in order to have a drawing of it independent of the platform
*/
@IBDesignable public class PathBasedButton: UIControl {

    // MARK: Internal properties
    
    /// The layer containing the actual shape
    private var shapeLayer = CAShapeLayer()
    
    // MARK: - Exposed properties
    
    /// The path required to draw the button.
    var path : CGPath? {
        get {
            return shapeLayer.path
        }
        set(newVal) {
            shapeLayer.path = newVal
            shapeLayer.setNeedsDisplay()
        }
    }
    
    /// This is the size in which the path was designed (to scale the drawing properly)
    @IBInspectable var designSize = CGSize.zero
    
    /// The fill color for the path drawing the button
    @IBInspectable var pathFillColor : UIColor? {
        get {
            guard let cgFillColor = shapeLayer.fillColor else { return nil}
            return UIColor(cgColor: cgFillColor)
        }
        set(newVal) {
            shapeLayer.fillColor = newVal?.cgColor
        }
    }
    
    /// The stroke color for the path drawing the button
    @IBInspectable var pathStrokeColor : UIColor? {
        get {
            guard let cgFillColor = shapeLayer.strokeColor else { return nil}
            return UIColor(cgColor: cgFillColor)
        }
        set(newVal) {
            shapeLayer.strokeColor = newVal?.cgColor
        }
    }
    
    /// The line width for the path drawing the button
    @IBInspectable var pathLineWidth : CGFloat {
        get {
            return shapeLayer.lineWidth
        }
        set(newVal) {
            shapeLayer.lineWidth = newVal
        }
    }
    
    /// Whether the scale process  should preserve the aspect ratio of the original image
    @IBInspectable var keepAspectRatio = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Initialization Override to add the shape layer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    init( path : CGPath? = nil) {
        super.init(frame: CGRect.zero)
        setupLayer()
    }
    
    // MARK: - Abstract Methods
    
    /**
        This method should be overriden by subclasses. It should setup at least the path and design size.
        It's recommended to set the colors (stroke and fill color) as the line width.
        The implementation of this class doesn't do anything.
    */
    public func configureButton()  {
        return
    }
    
    // MARK: - Layout support
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        adjustLayer()
    }
    
    override public var bounds: CGRect {
        didSet {
            adjustLayer()
        }
    }
    
    override public var frame: CGRect {
        didSet {
            adjustLayer()
        }
    }
    
    // MARK: - Support
    
    private func setupLayer() {
        if shapeLayer.superlayer == nil {
            pathFillColor = UIColor.black
            configureButton()
            layer.addSublayer(shapeLayer)
        }
    }
    
    /**
        Adjust the shape layer in order to have the path scaled to the required size, so it draws in the entire area for the view
    */
    private func adjustLayer() {
        
        // Check we don't have a zero design size
        guard designSize != CGSize.zero else { return }
        
        let wScale = bounds.width / designSize.width
        let hScale = bounds.height / designSize.height
        
        if keepAspectRatio {
            let scale = min(wScale,hScale)
            shapeLayer.transform = CATransform3DMakeScale(scale, scale, 1.0)
        } else {
            shapeLayer.transform = CATransform3DMakeScale(wScale, hScale, 1.0)
        }
        
    }

}

/**
    Generic button for a tool. All the tools when selected allow to be selected
 */
@IBDesignable public class ToolButton : PathBasedButton {
    
    /// Override to mark the button as selected
    public override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.cornerRadius = bounds.width * 0.5
                layer.masksToBounds = true
                layer.borderWidth = 1.0
                layer.borderColor = UIColor.black.cgColor
            } else {
                layer.borderWidth = 0.0
            }
        }
    }
    
    /// The shape tool associated with the tool button
    var toolType : ShapeToolType!
}
