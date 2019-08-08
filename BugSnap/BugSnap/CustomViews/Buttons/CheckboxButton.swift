//
//  CheckboxButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/6/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Representation of a checkbox button with different paths and an animation when toggling the selected state
*/
@IBDesignable public class CheckboxButton : PathBasedButton {
    
    /// The color of the path when is selected
    private var selectedColor = UIColor(red: 3, green: 137, blue: 6)
    
    /// The color of the path when is unselected
    private var unselectedColor = UIColor(red: 96, green: 97, blue: 99)
    
    /// The path when this button is selected
    private lazy var checked : CGPath = {
        /*  Shape   */
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 64, y: 9.5))
        pathRef.addCurve(to: CGPoint(x: 118.5, y: 64), control1: CGPoint(x: 94.1, y: 9.5), control2: CGPoint(x: 118.5, y: 33.9))
        pathRef.addCurve(to: CGPoint(x: 64, y: 118.5), control1: CGPoint(x: 118.5, y: 94.1), control2: CGPoint(x: 94.1, y: 118.5))
        pathRef.addCurve(to: CGPoint(x: 9.5, y: 64), control1: CGPoint(x: 33.9, y: 118.5), control2: CGPoint(x: 9.5, y: 94.1))
        pathRef.addCurve(to: CGPoint(x: 64, y: 9.5), control1: CGPoint(x: 9.5, y: 33.9), control2: CGPoint(x: 33.9, y: 9.5))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 64, y: 18.875))
        pathRef.addCurve(to: CGPoint(x: 18.875, y: 64), control1: CGPoint(x: 39.078, y: 18.875), control2: CGPoint(x: 18.875, y: 39.078))
        pathRef.addCurve(to: CGPoint(x: 64, y: 109.125), control1: CGPoint(x: 18.875, y: 88.922), control2: CGPoint(x: 39.078, y: 109.125))
        pathRef.addCurve(to: CGPoint(x: 109.125, y: 64), control1: CGPoint(x: 88.922, y: 109.125), control2: CGPoint(x: 109.125, y: 88.922))
        pathRef.addCurve(to: CGPoint(x: 64, y: 18.875), control1: CGPoint(x: 109.125, y: 39.078), control2: CGPoint(x: 88.922, y: 18.875))
        pathRef.closeSubpath()

        
        /*  Shape 2  */
        let pathRef2 = pathRef
        pathRef2.move(to: CGPoint(x: 31.272, y: 69.005))
        pathRef2.addCurve(to: CGPoint(x: 58.875, y: 88.5), control1: CGPoint(x: 33.375, y: 70.5), control2: CGPoint(x: 55.875, y: 88.5))
        pathRef2.addCurve(to: CGPoint(x: 96.125, y: 44.25), control1: CGPoint(x: 62.375, y: 88.5), control2: CGPoint(x: 95.961, y: 44.741))
        pathRef2.addCurve(to: CGPoint(x: 88.798, y: 37.603), control1: CGPoint(x: 96.875, y: 42), control2: CGPoint(x: 91.125, y: 36.75))
        pathRef2.addCurve(to: CGPoint(x: 57.176, y: 75.877), control1: CGPoint(x: 87.455, y: 38.096), control2: CGPoint(x: 58.978, y: 75.754))
        pathRef2.addCurve(to: CGPoint(x: 37.875, y: 61.75), control1: CGPoint(x: 55.375, y: 76), control2: CGPoint(x: 39.375, y: 63))
        pathRef2.addCurve(to: CGPoint(x: 31.272, y: 69.005), control1: CGPoint(x: 36.375, y: 60.5), control2: CGPoint(x: 30.375, y: 67.25))
        pathRef2.closeSubpath()
       
        return pathRef as CGPath
    }()
    
    /// The path of this button when is unselected
    private lazy var unchecked : CGPath = {
        /*  Shape   */
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 64, y: 9.5))
        pathRef.addCurve(to: CGPoint(x: 118.5, y: 64), control1: CGPoint(x: 94.1, y: 9.5), control2: CGPoint(x: 118.5, y: 33.9))
        pathRef.addCurve(to: CGPoint(x: 64, y: 118.5), control1: CGPoint(x: 118.5, y: 94.1), control2: CGPoint(x: 94.1, y: 118.5))
        pathRef.addCurve(to: CGPoint(x: 9.5, y: 64), control1: CGPoint(x: 33.9, y: 118.5), control2: CGPoint(x: 9.5, y: 94.1))
        pathRef.addCurve(to: CGPoint(x: 64, y: 9.5), control1: CGPoint(x: 9.5, y: 33.9), control2: CGPoint(x: 33.9, y: 9.5))
        pathRef.closeSubpath()
        pathRef.move(to: CGPoint(x: 64, y: 18.875))
        pathRef.addCurve(to: CGPoint(x: 18.875, y: 64), control1: CGPoint(x: 39.078, y: 18.875), control2: CGPoint(x: 18.875, y: 39.078))
        pathRef.addCurve(to: CGPoint(x: 64, y: 109.125), control1: CGPoint(x: 18.875, y: 88.922), control2: CGPoint(x: 39.078, y: 109.125))
        pathRef.addCurve(to: CGPoint(x: 109.125, y: 64), control1: CGPoint(x: 88.922, y: 109.125), control2: CGPoint(x: 109.125, y: 88.922))
        pathRef.addCurve(to: CGPoint(x: 64, y: 18.875), control1: CGPoint(x: 109.125, y: 39.078), control2: CGPoint(x: 88.922, y: 18.875))
        pathRef.closeSubpath()
 
        return pathRef as CGPath
    }()
    
    
    // MARK: - Override Path Based Button
    
    public override func configureButton() {
        
        designSize = CGSize(width: 128, height: 128)
        path = isSelected ? checked : unchecked
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 36, height: 36))
        pathLineWidth = 0.0
        pathStrokeColor = nil
        pathFillColor = isSelected ? selectedColor : unselectedColor
    }
    
    /// Sets the path & fill color depending on the current selection state
    public override var isSelected: Bool {
        didSet {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.3)
            path = isSelected ? checked : unchecked
            pathFillColor = isSelected ? selectedColor : unselectedColor
            CATransaction.commit()
        }
    }
}

/**
    Implementation of a checkbox with a label
*/
@IBDesignable public class CheckboxControl: UIView {
    
    // MARK: - Private Properties
    
    /// The checkbox button reflecting the state of this control
    private var checkboxButton : CheckboxButton!
    
    // MARK: - Public properties
    
    /// The current state for the checkbox button
    var isSelected : Bool {
        get {
            return checkboxButton.isSelected
        }
        set(newVal) {
            checkboxButton.isSelected = newVal
        }
    }
    
    /// Handler when the value has changed
    var onValueChanged : ((Bool)->Void)? = nil

    // MARK: - Initialization
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(label: "")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup(label: "")
    }
    
    public init( label : String ) {
        super.init(frame: CGRect.zero)
        setup(label: label)
    }
    
    // MARK: - Setup
    
    private func setup( label text : String = "" , maxLabelWidth : CGFloat = 150.0 ) {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.text = text
        
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: maxLabelWidth).isActive = true
     
        checkboxButton = CheckboxButton()
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkboxButton)
        checkboxButton.leadingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        checkboxButton.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        checkboxButton.widthAnchor.constraint(equalToConstant: 36.0).isActive = true
        checkboxButton.heightAnchor.constraint(equalTo: checkboxButton.widthAnchor).isActive = true
        checkboxButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        checkboxButton.isUserInteractionEnabled = false
        
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
    }

    @objc func onTap() {
        isSelected = !isSelected
        onValueChanged?(isSelected)
    }
}
