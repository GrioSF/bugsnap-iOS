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
public class ShapesView: UIImageView, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    /// The container scroll view
    weak var scrollView : UIScrollView? = nil
    
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
    
    /// The original transformed frame for the selected shape
    private var shapeInitialFrame = CGRect.zero
    
    /// the last valid scale
    private var lastValidScale = CGSize.zero
    
    // MARK: - Gestures
    
    /// The tap gesture recognizer
    private var tap : UITapGestureRecognizer!
    
    /// The pan gesture recognizer
    private var pan : UIPanGestureRecognizer!
    
    /// The scroll pan gesture recognizer
    private var scrollPan : UIPanGestureRecognizer!
    
    /// The pinch gesture recognizer
    private var pinch : UIPinchGestureRecognizer!
    
    /// The initial content offset for the scroll view
    private var initialContentOffset = CGPoint.zero
    
    /// The initial scale for the scroll view
    private var initialScale : CGFloat = 1.0
    
    // MARK: - Initialization
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestures()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestures()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        setupGestures()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setupGestures()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        setupGestures()
    }
    
    // MARK: - Gestures Support
    
    private func setupGestures() {
        guard tap == nil else { return }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(gesture:)))
        tap.numberOfTouchesRequired = 1
        addGestureRecognizer(tap)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(gesture:)))
        pan.maximumNumberOfTouches = 1
        pan.delegate = self
        addGestureRecognizer(pan)
        
        scrollPan = UIPanGestureRecognizer(target: self, action: #selector(onScrollPan(gesture:)))
        scrollPan.minimumNumberOfTouches = 2
        scrollPan.maximumNumberOfTouches = 2
        scrollPan.delegate = self
        addGestureRecognizer(scrollPan)
        
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(gesture:)))
        pinch.delegate = self
        addGestureRecognizer(pinch)
        
    }
    
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
        shapes.removeAll {
            return $0 === shape
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)
        CATransaction.setCompletionBlock {
            shape.removeFromSuperlayer()
        }
        shape.opacity = 0.0
        CATransaction.commit()
    }
    
    // MARK: - Support for the container scroll view
    
    func touchesShouldBegin( _ touches: Set<UITouch>, with event: UIEvent?) -> Bool {
        return true
    }
    
    // MARK: - Gestures Callback
    
    @objc func onTap( gesture : UITapGestureRecognizer ) {
        
        // Give the focus to the text view if we're tapping inside the selected shape of a text view
        if let textView = selectedShape as? TextShapeProtocol,
           selectedShape!.selectionFrame.contains(gesture.location(in: self)) {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                textView.becomeFirstResponder()
            }
            return
        }
        
        // Deselect the previous shape
        selectedShape?.isSelected = false
        selectedShape = nil
        
        if let tooltype = currentToolType,
            tooltype == TextShape.self {
            onPanBegan(point: gesture.location(in: self))
            onPanEnded(point: gesture.location(in: self))
        }
        else
        if let shape = detectSelectedShape(point: gesture.location(in: self)) {
            selectedShape = shape
            shape.isSelected = true
        }
    }
    
    @objc func onPan( gesture : UIPanGestureRecognizer ) {
        let point = gesture.location(in: self)
        switch gesture.state {
            case .began:
                disableScroll()
                onPanBegan(point: point)
            case .changed:
                onPanChanged(point: point)
            case .ended:
                enableScroll()
                onPanEnded(point: point)
            case .cancelled,.failed:
                enableScroll()
                onPanCancelled(point: point)
                print("pan cancelled")
            default:
                break
        }
    }
    
    @objc func onScrollPan ( gesture : UIPanGestureRecognizer ) {
        
        switch gesture.state {
        case .began:
            disableScroll()
            initialContentOffset = scrollView!.contentOffset
        case .changed:
            let translation = gesture.translation(in: self)
            let offset = CGPoint(x: -translation.x*scrollView!.zoomScale+initialContentOffset.x,
                                 y: -translation.y*scrollView!.zoomScale+initialContentOffset.y)
            
            scrollView?.setContentOffset( offset , animated: false)
        case .ended:
            enableScroll()
            let translation = gesture.translation(in: self)
            let maxOffset = CGPoint(x: bounds.width*scrollView!.zoomScale - scrollView!.bounds.width, y: bounds.height*scrollView!.zoomScale - scrollView!.bounds.height)
            
            let offset = CGPoint(x: min(max(-translation.x*scrollView!.zoomScale+initialContentOffset.x,0),maxOffset.x),
                                 y: min(max(-translation.y*scrollView!.zoomScale+initialContentOffset.y,0),maxOffset.y))
            scrollView?.setContentOffset( offset , animated: true)
        case .failed,.cancelled:
            enableScroll()
            scrollView?.setContentOffset(initialContentOffset, animated: true)
            print("scroll pan cancelled!")
        default:
            break
        }
    }
    
    @objc func onPinch( gesture : UIPinchGestureRecognizer ) {
        switch gesture.state {
        case .began:
            disableScroll()
            initialScale = scrollView!.zoomScale
        case .changed:
            scrollView?.setZoomScale(gesture.scale*initialScale, animated: false)
        case .ended:
            enableScroll()
            scrollView?.setZoomScale(gesture.scale*initialScale, animated: true)
        case .cancelled,.failed:
            enableScroll()
            scrollView?.setZoomScale(initialScale, animated: true)
            print("Pinch cancelled!")
        default:
            break
        }
    }
    
    // MARK : Shape Pan Handling
    
    private func onPanBegan( point : CGPoint ) {
        initialPoint = point
        
        // Check the current type of shape and the last one on the queue
        if let shape = shapes.last,
            let toolType = currentToolType,
            shape.isComposed && shape.isKind(of: toolType) && selectedShape == nil {
            beginShapeCreation(point: point)
            return
        }
        
        // Check if we're trying to scale or move an already selected shape
        if let selected = selectedShape {
            let frame = selected.frame
            let scaleFrame = CGRect(x: frame.bottomRight.x - 20.0, y: frame.bottomRight.y - 20.0, width: 40.0, height: 40.0)
            scalingShape = scaleFrame.contains(point)
            
            // If we're scaling or moving the shape
            if scalingShape || selected.selectionFrame.contains(point) {
                lastValidScale = CGSize.zero
                shapeInitialFrame = frame
                return
            } else {
                selectedShape?.isSelected = false
                selectedShape = nil
            }
        }
        
        beginShapeCreation(point: point)
    }
    
    private func onPanChanged( point : CGPoint ) {
        
        if let tool =  shapes.last,
            selectedShape == nil && currentToolType != nil {
            tool.gestureMoved(point: point)
            
        // we're moving the shape
        } else if selectedShape != nil{
            implementShapeTransform(point: point)
        }
    }
    
    private func onPanEnded( point : CGPoint ) {
        if let tool =  shapes.last,
            selectedShape == nil  && currentToolType != nil {
            
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
            
            if tool is TextShapeProtocol {
                selectedShape = tool
            }
            
        } else if selectedShape !=  nil {
            applyShapeTransform(point: point)
        }
    }
    
    private func onPanCancelled( point : CGPoint ) {
        
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
    
    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == scrollPan && [pinch,pan].contains(otherGestureRecognizer) {
            return false
        }
        if gestureRecognizer == pinch && [scrollPan, pan].contains(otherGestureRecognizer) {
            return false
        }
        
        if gestureRecognizer == pan && [scrollPan, pinch].contains(otherGestureRecognizer) {
            return false
        }
        
        return true
    }
    
    // MARK: - Scroll View Management
    
    private func disableScroll() {
        scrollView?.panGestureRecognizer.isEnabled = false
        scrollView?.pinchGestureRecognizer?.isEnabled = false
    }
    
    private func enableScroll() {
        scrollView?.panGestureRecognizer.isEnabled = true
        scrollView?.pinchGestureRecognizer?.isEnabled = true
    }
    

    // MARK: - Selection support
    
    /**
        Given some point, detects whether is selecting a shape.
        - Parameter point: The point in this view for selecting a shape
        - Returns: A shape tool if found any, nil otherwise
    */
    private func detectSelectedShape( point : CGPoint ) -> ShapeTool? {
        
        for shape in shapes.reversed() {
            if shape.selectionFrame.contains(point) {
                return shape
            }
        }
        
        return nil
    }

    private func deselectSelectedShape() {
        if selectedShape != nil {
            
            if let textShape = selectedShape as? TextShapeProtocol,
                textShape.isFirstResponder {
                endEditing(false)
            }
            
            selectedShape?.isSelected = false
            selectedShape = nil
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
