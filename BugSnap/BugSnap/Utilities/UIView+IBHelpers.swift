//
//  UIView+IBHelpers.swift
//  My Math Helper
//
//  Created by Héctor García Peña on 4/30/19.
//  © 2019 Grio All rights reserved.
//

import Foundation
import UIKit

/// Key to associate an initial rotation with the view
var kInitialRotationVarKey = "kInitialRotationVarKey"

/**
    Extension to add some handy properties exposed in IB to customize views and diminish the assets size
*/
@IBDesignable extension UIView {
    
    ///  The zIndex corresponding to the layer
    @IBInspectable var zIndex : CGFloat {
        get {
            return layer.zPosition
        }
        set(newVal) {
            layer.zPosition = newVal
        }
    }
    
    /// Sets the corner radius for the view setting also the masks to bounds for the layer.
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set(newVal) {
            layer.cornerRadius = max(newVal,0)
            layer.masksToBounds = layer.cornerRadius > 0
            setNeedsDisplay()
        }
    }
    
    /// Sets the corner radius for the view setting also the masks to bounds for the layer (iPad only)
    @IBInspectable var cornerRadiusiPad : CGFloat {
        get {
            return layer.cornerRadius
        }
        set(newVal) {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                layer.cornerRadius = max(newVal,0)
                layer.masksToBounds = layer.cornerRadius > 0
                setNeedsDisplay()
            }
        }
    }
    
    /// Sets/gets the layer border width. Setting only works if the value provided is greater than zero
    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set(newVal) {
            guard newVal >= 0.0 else { return }
            layer.borderWidth = newVal
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set(newVal) {
            layer.borderColor = newVal?.cgColor
            setNeedsDisplay()
        }
    }
    
    
    /// Sets a rotation on the view via affine transform
    @IBInspectable var rotation: CGFloat {
        get {
            guard let initialRotation = objc_getAssociatedObject(self, &kInitialRotationVarKey) as? NSNumber else { return 0.0 }
            return CGFloat(initialRotation.floatValue)
        }
        set(newVal) {
            objc_setAssociatedObject(self, &kInitialRotationVarKey, NSNumber(floatLiteral: Double(newVal)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            transform = CGAffineTransform(rotationAngle: newVal.radians)
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    /// Sets the rotation for the view in degrees
    @IBInspectable var startAngle : CGFloat {
        get {
            guard let initialRotation = objc_getAssociatedObject(self, &kInitialRotationVarKey) as? NSNumber else { return 0.0 }
            return CGFloat(initialRotation.floatValue)
        }
        set(newVal) {
            objc_setAssociatedObject(self, &kInitialRotationVarKey, NSNumber(floatLiteral: Double(newVal)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            layer.transform = CATransform3DMakeRotation(newVal.radians, 0.0, 0.0, 1.0)
        }
    }
    
    /// The layer anchor point for this view
    @IBInspectable var anchorPoint : CGPoint {
        get {
            return layer.anchorPoint
        }
        set(newVal) {
            layer.anchorPoint = newVal
        }
    }
}
