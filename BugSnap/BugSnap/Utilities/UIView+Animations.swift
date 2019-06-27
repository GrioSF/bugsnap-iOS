//
//  UIView+Animations.swift
//  My Math Helper
//
//  Created by Héctor García Peña on 4/29/19.
//  © 2019 Grio All rights reserved.
//

import Foundation
import UIKit

/**
    Generic animations that can be used in a UIView
*/
extension UIView {
    
    /**
        Rotates this view the given number of cycles with the duration given the repeatitions number of times
     
        This animation adds the key "rotationAnimation" for the quartz animation to the underlying layer.
     
        - Parameter rotations: The number of cycles
        - Parameter duration: The duration for the animation (1 repeatition) in seconds
        - Parameter repetitions: The number of times the animation will repeat itself
    */
    func spin( cycles rotations:CGFloat , duration : TimeInterval, repetitions : Int) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(floatLiteral: .pi*2.0*Double(rotations))
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = Float(repetitions)
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    /**
        Animates scale and translation to center the view in its container
     
        - Parameter duration: The duration for the animation
        - Parameter completion: The completion block when the animation is either finished or interrupted
    */
    func centerOnScreen( scale: CGFloat,  duration : TimeInterval, completion : ((Bool)->Void)? = nil) {
        guard superview != nil else { return }
        let parentCenter = CGPoint(x: superview!.bounds.width * 0.5, y: superview!.bounds.height*0.5)
        let finalTransform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: parentCenter.x - center.x, y: parentCenter.y - center.y))
        UIView.animate(withDuration: duration, animations: {
            self.transform = finalTransform
        }, completion: completion)
    }
    
    /**
        Animates a view by adding a shadow and incrementing its size the specified number of times
     
        - Parameter repetitions: The number of times you want the view to increase its size with the shadow fx
        - Parameter completion: A closure to execute when the animation finishes
    */
    func glow( repetitions: Int, completion : (()->Void)? = nil) {
        layer.shadowColor = UIColor.purple.cgColor
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false
        
        let initialTransform = transform
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.autoreverse,.curveEaseInOut,.repeat,.allowUserInteraction], animations: {
            UIView.setAnimationRepeatCount(Float(repetitions))
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1).concatenating(initialTransform)
        }) { (_) in
            self.layer.shadowRadius = 0.0
            self.transform = initialTransform
            completion?()
        }
    }
    
    /**
        Animates a view to have a beating effect.
     
        The key for this animation is beat in case you wan to delete it. By default the animation goes on forever (or until is interrupted). After calling this method the beat animation is added to the layer of this view.
     
        - Parameter maxScale: The maximum scale that should be reached
        - Parameter duration: The duration for a single beat.
        - Parameter repetitions: The number of repetitions for the beat loop
    */
    func beat( maxScale : CGFloat = 1.005, duration : TimeInterval = 1.4, repetitions : Float = HUGE ) {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [
            NSNumber(floatLiteral: Double(1.0)),
            NSNumber(floatLiteral: Double(0.995)*Double.random(in: 0.9...1.0)),
            NSNumber(floatLiteral: Double(maxScale)*Double.random(in: 0.99...1.01)),
            NSNumber(floatLiteral: Double(maxScale)*Double.random(in: 0.99...1.01)),
            NSNumber(floatLiteral: Double(1.0))
        ]
        
        animation.keyTimes = [
            NSNumber(floatLiteral: Double(0.0)),
            NSNumber(floatLiteral: Double(0.1)),
            NSNumber(floatLiteral: Double(0.4)),
            NSNumber(floatLiteral: Double(0.7)),
            NSNumber(floatLiteral: Double(1.0))
        ]
        
        animation.timingFunctions = [
            CAMediaTimingFunction(name: .linear),
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .linear),
            CAMediaTimingFunction(name: .easeInEaseOut)
        ]
        animation.duration = duration
        animation.repeatCount = repetitions
        animation.calculationMode = .linear
        layer.add(animation, forKey: "beat")
    }
    
    /**
        Horizontal animation starting with the current position of the view until it disappears, then it continues from the beginning
        of the screen in an endless loop. Each sweep in the screen takes duration time.
        - Parameter duration: The time to cross the screen horizontally
    */
    func transverseHorizontally( duration : TimeInterval) {
        
        layer.removeAnimation(forKey: "transverseHorizontally")
        
        let startX = Double(-bounds.width*0.5)
        let endX =  Double(superview!.bounds.width+bounds.width*0.5)
        let translation = CABasicAnimation(keyPath: "position.x")
        translation.fromValue = NSNumber(floatLiteral: startX)
        translation.toValue = NSNumber(floatLiteral: endX)
        translation.duration = duration
        translation.repeatCount = HUGE
        translation.timeOffset = duration*Double(center.x)/(endX - startX)
        translation.timingFunction = CAMediaTimingFunction(name: .linear)
        layer.add(translation, forKey: "transverseHorizontally")
    }
    
    /**
        Docks the view in the right side with an animation
        This view should be larger than the view where is supposed to dock on the right
        - Parameter view: The view used as reference to dock (that will work for computing the transform to translate to the left, so docking in the right)
        - Parameter duration: The duration of the animation (defaults to 10 secs)
        - Parameter delay: The delay to start the animation (defaults to 0.5 secs)
        - Parameter completion: A handler when the animation finishes
    */
    func dockRigthSide( within view : UIView, duration : TimeInterval = 10, delay : TimeInterval = 0.5 , completion : (()->Void)? = nil ) {
        let width = view.bounds.width
        let myWidth = self.bounds.width
        
        let finalTransform = CGAffineTransform(translationX: width - myWidth, y: 0)
        
        UIView.animate(withDuration: 10.0, delay: 0.5, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            self.transform = finalTransform
        }) { (_) in
            completion?()
        }
    }
    
    func oscillate3D() {
        
        var perspective = CATransform3DIdentity
        perspective.m34 = CGFloat(-1.0/435)
        layer.sublayerTransform = perspective
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(.pi*15.0/180.0, 1.0, 0.0, 0.0))
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(-.pi*15.0/180.0, 1.0, 0.0, 0.0))
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = HUGE
        
        for view in subviews {
            view.layer.removeAnimation(forKey: "oscillate")
            view.layer.add(animation, forKey: "oscillate")
        }
    }
    
    /**
        Checks whether the presentation layer (what we see in the screen during a quartz animation) is hit by the point
     
        This test hit is in coordinates relative to the parent layer that contains this view and its layer.
     
        - Parameter point: The point to test against.
    */
    func hitTestPresentation( point : CGPoint)->Bool {
        if let presentation = layer.presentation() {
            return presentation.frame.contains(point)
        }
        return false
    }
    
    /**
        Uses all the views for transverse the area horizontally
        - Parameter baseDuration: The base duration (ClosedRange) for transversing the area. The method will use random to generate different values
        - Parameter noise: Additional range for generating another random number and multiply by the base computed random interval
    */
    func transverseSubviewsHorizontally( baseDuration : ClosedRange<TimeInterval> =  35...60, noise : ClosedRange<Double> = 0.8...1.3) {
        
        for view in subviews {
            let duration = Double.random(in: baseDuration)*Double.random(in: 0.8...1.3)
            view.transverseHorizontally(duration: duration)
        }
    }
    
    
    /**
        Presents the fx of closing the view as an iris.
        To work properly, the view should be layed out and have the right dimensions (since the iris is positioned in the center of the view)
        - Parameter duration: Defaults to 0.5 secs
        - Parameter completion: The closure to be called when the animation finishes
    */
    func irisClose( duration : TimeInterval = 0.5 , completion : ((Bool)->Void)? = nil) {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        mask = view
        let dimension = CGFloat(sqrtf(Float(bounds.width*bounds.width + bounds.height*bounds.height)))
        view.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        view.cornerRadius = dimension * 0.5
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.beginFromCurrentState,.curveEaseIn], animations: {
            view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { (finished) in
            self.mask = nil
            completion?(finished)
        }
    }
    
    /**
     Presents the fx of opening the view as an iris.
     To work properly, the view should be layed out and have the right dimensions (since the iris is positioned in the center of the view)
     - Parameter duration: Defaults to 0.5 secs
     - Parameter completion: The closure to be called when the animation finishes
     */
    func irisOpen( duration : TimeInterval = 0.5 , completion : ((Bool)->Void)? = nil ) {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        mask = view
        let dimension = CGFloat(sqrtf(Float(bounds.width*bounds.width + bounds.height*bounds.height)))
        view.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        view.cornerRadius = dimension * 0.5
        view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.beginFromCurrentState,.curveEaseOut], animations: {
            view.transform = CGAffineTransform.identity
        }) { (finished) in
            self.mask = nil
            completion?(finished)
        }
    }
    
    /**
        Animates the background color of the view to the color specified with the duration specified (by default 0.3 secs)
        - Parameter color: The target color for the background of this view
        - Parameter duration: The duration of the animation. Defaults to 0.3
    */
    func fade( to color: UIColor, duration : TimeInterval = 0.3 ) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            self.backgroundColor = color
        }, completion: nil)
    }
    
}
