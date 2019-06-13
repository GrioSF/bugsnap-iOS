//
//  MarkupEditorViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/12/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import UIKit

/**
    The main view controller for annotating the image.
 
*/
public class MarkupEditorViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate {
    
    // MARK: - Exposed Properties
    
    /// The screen snapshot
    var screenSnapshot : UIImage? = nil
    
    // MARK: - Current Drawing Parameters
    
    /// The stroke color
    private var graphicProperties = GraphicProperties()

    // MARK: - UI Properties
    
    /// The scroll view to support zooming into the image
    private var scrollView = UIScrollView()
    
    /// The content view for the scroll view
    private var snapshot = UIImageView()
    
    /// The stroke bar button item
    private var strokeButton : StrokeButton!
    
    // MARK: - View Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        snapshot.image = UIImage(named: "TestImage")
        setup()        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupToolbar()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    // MARK: - Setup for the UI elements
    
    
    
    private func setup() {
        setupNavigationBar()
        setupScrollView()
        setupImageView()
    }
    
    private func setupNavigationBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
        navigationItem.setLeftBarButton(doneButton, animated: false)
        navigationController?.setToolbarHidden(false, animated: false)
        title = "Markup"
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.maximumZoomScale = UIScreen.main.scale
        scrollView.minimumZoomScale = 1.0
        scrollView.bouncesZoom = true
        scrollView.bounces = false
        scrollView.delegate = self
    }
    
    private func setupImageView() {
        snapshot.contentMode = .center
        snapshot.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(snapshot)
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[snapshot]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["snapshot":snapshot]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[snapshot]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["snapshot":snapshot]))
    }
    
    private func setupToolbar() {
        strokeButton = StrokeButton()
        strokeButton.addTarget(self, action: #selector(onStroke), for: .touchUpInside)
        let strokeButtonItem = UIBarButtonItem(customView: strokeButton)
        navigationController?.toolbar.setItems([strokeButtonItem,
                                                colorButton(color: UIColor.black),
                                                colorButton(color: UIColor.white),
                                                colorButton(color: UIColor.red, selected: true),
                                                colorButton(color: UIColor.blue),
                                                colorButton(color: UIColor.green),
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            ], animated: true)
    }
    
    private func colorButton( color : UIColor , selected : Bool = false) -> UIBarButtonItem {
        let button = ColorSelectorButton()
        button.pathFillColor = color
        button.pathLineWidth = 2.0
        button.addTarget(self, action: #selector(onColor(button:)), for: .touchUpInside)
        button.isSelected = selected
        button.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40.0, height: 40.0))
        
        if selected {
            strokeButton.pathFillColor = color
            graphicProperties.strokeColor = color
        }
        
        return UIBarButtonItem(customView: button)
    }
    
    // MARK: - UICallback
    
    @objc func onDone() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onStroke() {
        
        if let strokeView = snapshot.subviews.last as? StrokeView,
            strokeView.isUserInteractionEnabled {
            scrollView.isScrollEnabled = true
            strokeView.isUserInteractionEnabled = false
            strokeView.backgroundColor = UIColor.clear
            snapshot.isUserInteractionEnabled = false
            return
        }
        
        let strokeView = StrokeView()
        strokeView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        strokeView.bounds = snapshot.bounds
        strokeView.center = CGPoint(x: strokeView.bounds.width * 0.5, y: strokeView.bounds.height * 0.5)
        strokeView.isUserInteractionEnabled = true
        strokeView.graphicProperties = graphicProperties
        scrollView.isScrollEnabled = false
        snapshot.isUserInteractionEnabled = true
        snapshot.addSubview(strokeView)
    }
    
    @objc func onColor( button : ColorSelectorButton? ) {
        guard let items = navigationController?.toolbar.items else { return }
        
        // Deselect previous color
        for item in items {
            if let control = item.customView as? UIControl,
               control.isSelected {
                control.isSelected = false
                break
            }
        }
        
        // Select current color
        strokeButton.pathFillColor = button?.pathFillColor
        graphicProperties.strokeColor = button?.pathFillColor
        button?.isSelected = true
        updateTool()
    }
    
    private func updateTool() {
        if var drawable = snapshot.subviews.last as? DrawableView {
            drawable.graphicProperties = graphicProperties
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return snapshot
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
