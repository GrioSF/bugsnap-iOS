//
//  ToolOptionsViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/26/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    A floating view that will contain color options. The space beneath the color palette is necessary to add additional
    tool options. This view controller is intended to be subclassed and add in the contentView property the required controls
 */
public class ToolOptionsViewController: UIViewController {
    
    // MARK: - Exposed properties
    
    /// The content view where the other controls will be layout
    weak var contentView : UIView!
    
    /// The handler when a color is selected
    var onColorSelectedHandler : ((UIColor?)->Void)? = nil
    
    /// The height for this view controller. This height should be set before showing the view controller
    var height = CGFloat(100.0)
    
    /// The color selected
    var colorSelected = UIColor(red: 0, green: 0, blue: 0) {
        didSet {
            selectColor(color: colorSelected)
        }
    }
    
    // MARK: - UI Components
    
    /// Array for selecting the colors programmatically
    private var colorButtons = [ColorSelectorButton]()
    
    /// The last selected color
    private weak var lastSelectedColor : ColorSelectorButton? = nil
    
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onSwipeDown(gesture:)))
        view.addGestureRecognizer(pan)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectColor(color: colorSelected)
    }
    
    // MARK: - Utilty methods
    
    /**
        Adds itself as a child view controller with an animation coming from the button
        - Parameter parent: The parent view controller managing this view controller
    */
    func show( parent : UIViewController ) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        willMove(toParent: parent)
        parent.view.addSubview(view)
        view.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor).isActive = true
        
        view.transform = CGAffineTransform(translationX: 0.0, y: height)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            self.view.transform = CGAffineTransform.identity
        }) { (_) in
            parent.addChild(self)
        }
    }
    
    /**
        Hides itself and it's removed from the parent view controller
    */
    func hide() {
        guard parent != nil else { return }
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            self.view.transform = CGAffineTransform(translationX: 0.0, y: self.height)
        }) { (_) in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupBackground()
        setupFloatingMarker()
        setupColorMenu()
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor.clear
        
        let fxView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        fxView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fxView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":fxView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":fxView]))
        contentView = fxView.contentView
    }
    
    private func setupColorMenu() {
        
        guard colorButtons.count == 0 else { return }
        
        let label = UILabel()
        label.textColor = UIColor(red: 194, green: 194, blue: 194)
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Color"
        label.sizeToFit()
        label.setNeedsDisplay()
        
        contentView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 36.0).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0).isActive = true
        
        // Add the color menu
        let colors = [ UIColor(red: 0, green: 0, blue: 0),
                       UIColor(red: 255, green: 255, blue: 255),
                       UIColor(red: 82, green: 149, blue: 234),
                       UIColor(red: 97, green: 176, blue: 63),
                       UIColor(red: 252, green: 244, blue: 82),
                       UIColor(red: 236, green: 112, blue: 49),
                       UIColor(red: 214, green: 46, blue: 31),
                       UIColor(red: 146, green: 27, blue: 244)
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
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["width": NSNumber(floatLiteral:Double(colors.count) * buttonSize )], views: ["view":stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view(height)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["height": NSNumber(floatLiteral:buttonSize )], views: ["view":stackView]))
        
        colors.forEach {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.bounds = CGRect(x: 0, y: 0, width: CGFloat(buttonSize), height: CGFloat(buttonSize))
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(onColorSelected(gesture:)))
            container.addGestureRecognizer(tap)
            
            let button = ColorSelectorButton()
            button.pathFillColor = $0
            button.pathStrokeColor = nil
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isUserInteractionEnabled = false
            
            container.addSubview(button)
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
            colorButtons.append(button)
            
            stackView.addArrangedSubview(container)
        }
    }
    
    private func setupFloatingMarker() {
        let view = UIView()
        view.backgroundColor = UIColor(red: 172, green: 172, blue: 172)
        view.cornerRadius = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(view)
        view.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0).isActive = true
        view.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        
    }
    
    // MARK: - UI Callback
    
    @objc func onColorSelected( gesture : UITapGestureRecognizer ) {
        
        if let colorButton = gesture.view?.subviews.first as? ColorSelectorButton,
            !colorButton.isSelected {
            colorButton.isSelected = true
            if lastSelectedColor != nil {
                lastSelectedColor?.isSelected = false
            }
            onColorSelectedHandler?(colorButton.pathFillColor)
            lastSelectedColor = colorButton
        }
    }
    
    @objc func onSwipeDown( gesture : UIPanGestureRecognizer ) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        switch gesture.state {
            case .changed:
                if translation.y > 0 && translation.y < height {
                    view.transform = CGAffineTransform(translationX: 0.0, y: translation.y)
            }
            case .ended:
                guard translation.y > 0 && velocity.y > 100.0  else {
                    restorePosition()
                    return
                }
                hide()
            case .cancelled:
                restorePosition()
            default :
                print("")
        }
    }
    
    // MARK: - Support
    
    private func restorePosition() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState,.curveEaseOut], animations: {
            self.view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    private func selectColor( color : UIColor ) {
        colorButtons.forEach {
            $0.isSelected = $0.pathFillColor == color
            if $0.isSelected {
                self.lastSelectedColor = $0
            }
        }
    }

}
