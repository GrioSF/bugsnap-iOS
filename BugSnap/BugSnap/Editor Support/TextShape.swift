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
    
    /// Whether this shape is the first responder
    var isFirstResponder : Bool { get }
    
    /// To become the first responder
    func becomeFirstResponder()
    
}

typealias TextShapeType = CALayer&ShapeProtocol&ShapeGestureHandler&TextShapeProtocol

/**
    Implementation of a text layer for drawing it as a shape
*/
public class TextShape: CALayer, ShapeProtocol, ShapeGestureHandler , TextShapeProtocol, UITextViewDelegate {
    
    
    // MARK: - For the text
    
    /// The current selection handler
    private var selectionHandler : CAShapeLayer? = nil
    
    /// An underlying label that will allow to render text
    private var underlyingTextCapture = UITextView()
    
    /// The text layer that will render the text
    private var textLayer : CALayer!
    
    /// The font for this text layer
    private var font = UIFont.systemFont(ofSize: 10.0)
    
    // MARK: - Text Protocol
    
    /// The actual text that will be rendered
    public var text : String? = nil {
        didSet {
            if text == nil {
                // do something useful when you clear the text
            } else {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .left
                paragraph.lineBreakMode = .byWordWrapping
                
                let maxDimensionsText = CGSize(width: superlayer!.superlayer!.bounds.width - underlyingTextCapture.frame.origin.x - 40.0, height: CGFloat(HUGE))
                let boundingRect = (text! as NSString).boundingRect(with:maxDimensionsText,
                                                                    options: .usesLineFragmentOrigin,
                                                                    attributes: [
                                                                        NSAttributedString.Key.font : font,
                                                                        NSAttributedString.Key.paragraphStyle : paragraph
                                                                    ], context: nil)
                let increasedSize = CGSize(width: boundingRect.width + 40.0, height: boundingRect.height + 30.0)
                let frame = CGRect(origin: underlyingTextCapture.frame.origin, size: increasedSize)
                //underlyingTextCapture.frame = frame
                bounds = frame.originAnchoredRect
                underlyingTextCapture.setNeedsLayout()
                
                //underlyingTextCapture.frame = CGRect(x: Double(position.x), y: Double(position.y), width: ceil(Double(boundingRect.width))+2.0, height: ceil(Double(boundingRect.height)))
                //bounds = underlyingTextCapture.frame.originAnchoredRect
                //underlyingTextCapture.setNeedsDisplay()
            }
        }
    }
    
    var isFirstResponder: Bool { return underlyingTextCapture.isFirstResponder }
    
    func becomeFirstResponder() {
        if underlyingTextCapture.superview != nil {
            underlyingTextCapture.isUserInteractionEnabled = true
            underlyingTextCapture.becomeFirstResponder()
        }
    }
    
    // MARK: - ShapeGestureHandler Properties
    
    public var initialPoint = CGPoint.zero
    
    public var isSelected: Bool = false {
        didSet {
            if isSelected {
                borderWidth = 1.0
                borderColor = UIColor.darkGray.cgColor
                
                if selectionHandler == nil  {
                    selectionHandler = CAShapeLayer()
                }
                selectionHandler?.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
                selectionHandler?.fillColor = UIColor(red: 55, green: 123, blue: 246).cgColor
                selectionHandler?.position = bounds.bottomRight.convert(with: CGPoint(x: 5.0, y: 5.0))
                addSublayer(selectionHandler!)
                
            } else {
                borderWidth = 0.0
                borderColor = nil
                selectionHandler?.removeFromSuperlayer()
                selectionHandler = nil 
            }
        }
    }
    
    public var isComposed: Bool = false
    
    
    // MARK: - ShapeProtocol Implementation
    
    public var enclosingFrame: CGRect = CGRect.zero
    
    public var selectionFrame: CGRect {
        
        if frame.width < 40.0 || frame.height < 40.0 {
            return CGRect(x: frame.origin.x - 20.0, y: frame.origin.y - 20.0, width: frame.width + 40.0, height: frame.height + 40.0)
        } else {
            return frame
        }
    }
    
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
            font = UIFont(name: "HelveticaNeue-Medium", size: graphicProperties.fontSize)!
            underlyingTextCapture.font = font
            underlyingTextCapture.textColor = graphicProperties.strokeColor ?? UIColor.black
            textLayer = underlyingTextCapture.layer
            let newActions = [String : CAAction]()
            textLayer.actions = newActions
            actions = newActions
        }
    }
    
    public var handler: ShapeGestureHandler? { return self}
    
    public func implementScale(scale: CGSize) {
        
    }
    
    // MARK: - Override positioning
    
    public override var frame : CGRect {
        didSet {
            underlyingTextCapture.frame = frame
            selectionHandler?.position = bounds.bottomRight.convert(with: CGPoint(x: 5.0, y: 5.0))
        }
    }
    
    public override var position : CGPoint {
        didSet {
            underlyingTextCapture.frame = frame
            selectionHandler?.position = bounds.bottomRight.convert(with: CGPoint(x: 5.0, y: 5.0))
        }
    }
    
    public override var bounds : CGRect {
        didSet {
            underlyingTextCapture.frame = frame
            selectionHandler?.position = bounds.bottomRight.convert(with: CGPoint(x: 5.0, y: 5.0))
        }
    }
    
    public override func removeFromSuperlayer() {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState,.curveEaseIn], animations: {
            self.underlyingTextCapture.alpha = 0.0
        }) { (_) in
            self.underlyingTextCapture.removeFromSuperview()
            super.removeFromSuperlayer()
        }
    }
    
    // MARK: - ShapeGestureHandler methods
    
    public func gestureBegan(point: CGPoint) {
        initialPoint = point
        if textLayer.superlayer == nil {
            
            underlyingTextCapture.isScrollEnabled = false
            underlyingTextCapture.isSelectable = false
            underlyingTextCapture.isEditable = true
            underlyingTextCapture.backgroundColor = UIColor.clear
            underlyingTextCapture.dataDetectorTypes = UIDataDetectorTypes()
            underlyingTextCapture.delegate = self
            
            textLayer = underlyingTextCapture.layer
            
            let minimumSizePoint = CGPoint(x: point.x + 40.0, y: point.y + graphicProperties.fontSize+30.0 )
            enclosingFrame = updatedFrame(point: minimumSizePoint)
        }
    }
    
    public func gestureMoved(point: CGPoint) {
        
        // At the beginning the shape doesn't support moving for creation
    }
    
    public func gestureCancelled(point: CGPoint) {
        endDragging()
    }
    
    public func gestureEnded(point: CGPoint) {
        endDragging()
    }
    

    
    public func updatedFrame(point: CGPoint) -> CGRect {
        let rect = CGRect(x: min(initialPoint.x,point.x), y: min(initialPoint.y,point.y), width: abs(point.x-initialPoint.x), height: abs(point.y-initialPoint.y))
        return rect
    }
    
    // MARK: - Support
    
    private func endDragging() {
        underlyingTextCapture.frame = enclosingFrame
        enclosingFrame = enclosingFrame.originAnchoredRect
        
        if let view = superlayer?.delegate as? UIView {
            view.addSubview(underlyingTextCapture)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.underlyingTextCapture.isSelectable = true
                self.underlyingTextCapture.becomeFirstResponder()
            }
        }
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
    
    // MARK: - UITextViewDelegate
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        isSelected = true
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let mutableString = NSMutableString(string: textView.text)
        mutableString.replaceCharacters(in: range, with: text)
        
        DispatchQueue.main.async {
            self.text = mutableString as String
        }
        
        return true
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        textView.isUserInteractionEnabled = false
    }
}
