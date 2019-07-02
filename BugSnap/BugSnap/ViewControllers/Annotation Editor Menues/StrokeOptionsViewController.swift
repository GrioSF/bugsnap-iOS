//
//  StrokeOptionsViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/26/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    A floating view that will contain color options and the brush size for the stroke tool
*/
public class StrokeOptionsViewController: ToolOptionsViewController {
    
    // MARK: - Exposed properties
    
    /// Handler when the line width changed
    var onLineWidthChangedHandler : ((CGFloat)->Void)? = nil
    
    /// The line width controlled by this view controller
    var lineWidth : CGFloat = 1.0 {
        didSet {
            slider.value = Float(lineWidth)
            updateLineWidth(width: lineWidth)
        }
    }
    
    // MARK: - UI Properties
    
    /// The line width circle
    private var lineWidthView = UIView()
    
    /// The slider
    private var slider = UISlider()
    
    // MARK: - View Controller Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBrushSize()
    }
    
    // MARK: - Setup
    
    private func setupBrushSize() {
        let label = UILabel()
        label.textColor = UIColor(red: 194, green: 194, blue: 194)
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Brush Size"
        label.sizeToFit()
        label.setNeedsDisplay()
        
        contentView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 70.0).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0).isActive = true
        
        slider.tintColor = UIColor(red: 96, green: 205, blue: 177)
        slider.minimumValue = 4.0
        slider.maximumValue = 44.0
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(slider)
        slider.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80.0).isActive = true
        slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50.0).isActive = true
        slider.addTarget(self, action: #selector(onLineWidthChanged(sender:)), for: .valueChanged)
        
        lineWidthView.translatesAutoresizingMaskIntoConstraints = false
        lineWidthView.backgroundColor = UIColor.black
        lineWidthView.cornerRadius = 15.0
        
        contentView.addSubview(lineWidthView)
        lineWidthView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        lineWidthView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        lineWidthView.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        lineWidthView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0).isActive = true
    }
    
    // MARK: - UICallback
    
    @objc func onLineWidthChanged( sender : UISlider ) {
        updateLineWidth(width: CGFloat(sender.value))
        onLineWidthChangedHandler?(CGFloat(sender.value))
    }
    
    // MARK: - Support
    private func updateLineWidth( width : CGFloat ) {
        let scale = width / lineWidthView.bounds.width
        lineWidthView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
