//
//  ShapesOptionsViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/26/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

class ShapesOptionsViewController: ToolOptionsViewController {
    
    // MARK: - Exposed properties

    /// the handler for actually selecting the shape
    var onShapeSelectedHandler : ((ShapeToolType)->Void)? = nil

    /// The previously selected tool
    var previouslySelectedTool : ShapeToolType? = nil
    
    /// The previously selected button
    private var previouslySelectedButton : ToolButton? = nil
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShapeTools()
    }
    

    // MARK: - Setup tools
    
    private func setupShapeTools() {
        let label = UILabel()
        label.textColor = UIColor(red: 194, green: 194, blue: 194)
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shape"
        label.sizeToFit()
        label.setNeedsDisplay()
        
        contentView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 70.0).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0).isActive = true
        
        
        let tools : [ToolButton] = [
            OvalTool(),
            RectangleTool(),
            //LineTool(),
            ForwardArrowTool()
            //BackwardArrowTool()
        ]
        
        let buttonSize = 36.0
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 70.0).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: CGFloat(buttonSize)).isActive = true
        
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2.0
        stackView.backgroundColor = UIColor.clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(stackView)
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["width": NSNumber(floatLiteral:Double(tools.count) * buttonSize * 1.5 )], views: ["view":stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view(height)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["height": NSNumber(floatLiteral:buttonSize )], views: ["view":stackView]))
        
        tools.forEach {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.bounds = CGRect(x: 0, y: 0, width: CGFloat(buttonSize*1.5), height: CGFloat(buttonSize))
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(onShapeTool(gesture:)))
            container.addGestureRecognizer(tap)
            
            $0.pathStrokeColor = UIColor.white
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = false
            
            container.addSubview($0)
            $0.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
            
            stackView.addArrangedSubview(container)
            
            $0.isSelected = $0.toolType == previouslySelectedTool
        }
    }
    
    // MARK: - UI Callback
    
    @objc func onShapeTool( gesture : UITapGestureRecognizer ) {
        if let toolButton = gesture.view?.subviews.first as? ToolButton,
            let shapeType = toolButton.toolType {
            
            if previouslySelectedButton != nil {
                previouslySelectedButton?.isSelected = false
            }
            toolButton.isSelected = true
            previouslySelectedButton = toolButton
            onShapeSelectedHandler?(shapeType)
        }
    }
}
