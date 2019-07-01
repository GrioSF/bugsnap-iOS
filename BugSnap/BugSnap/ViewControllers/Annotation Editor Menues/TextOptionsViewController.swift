//
//  TextOptionsViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/27/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    View controller presenting the options for text writing, which is basically
    the color and the font size (no option for selecting the font yet).
*/
class TextOptionsViewController: ToolOptionsViewController {

    // MARK: - Exposed properties
    
    /// Handler when the line width changed
    var onFontSizeChangedHandler : ((CGFloat)->Void)? = nil
    
    /// The font size managed by this view controller
    var fontSize : CGFloat = 14.0 {
        didSet {
            slider.value = Float(fontSize)
            //updateLineWidth(width: lineWidth)
        }
    }
    
    // MARK: - UI Properties
    
    /// The line width circle
    private var fontSizeView = UILabel()
    
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
        label.text = "Text Size"
        label.sizeToFit()
        label.setNeedsDisplay()
        
        contentView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 70.0).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0).isActive = true
        
        slider.tintColor = UIColor(red: 96, green: 205, blue: 177)
        slider.minimumValue = 14.0
        slider.maximumValue = 36.0
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(slider)
        slider.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80.0).isActive = true
        slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50.0).isActive = true
        slider.addTarget(self, action: #selector(onFontSizeChanged(sender:)), for: .valueChanged)
        
        fontSizeView.translatesAutoresizingMaskIntoConstraints = false
        fontSizeView.textColor = UIColor.black
        fontSizeView.text = "T"
        fontSizeView.textAlignment = .center
        fontSizeView.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: fontSize)
        
        contentView.addSubview(fontSizeView)
        fontSizeView.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        fontSizeView.leadingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 15.0).isActive = true
    }
    
    // MARK: - UICallback
    
    @objc func onFontSizeChanged( sender : UISlider ) {
        let fontSize =  CGFloat(sender.value)
        updateFontSize(pointSize: fontSize)
        onFontSizeChangedHandler?(fontSize)
    }
    
    // MARK: - Support
    private func updateFontSize( pointSize : CGFloat ) {
        fontSizeView.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: pointSize)
    }

}
