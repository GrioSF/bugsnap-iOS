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

    // MARK: - UI Properties
    
    /// The scroll view to support zooming into the image
    private var scrollView = UIScrollView()
    
    /// The content view for the scroll view
    private var snapshot = ShapesView()
    
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
        navigationController?.toolbar.setItems([toolButton(button: StrokeTool()),
                                                toolButton(button: RectangleTool()),
                                                toolButton(button: OvalTool()),
                                                customViewControl(control: LineWidthSelectorButton(), selector: #selector(onLineWidth(button:))),
                                                colorButton(color: UIColor.black, selected: true),
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            ], animated: true)
    }
    
    private func customViewControl( control : UIControl, selector : Selector ) -> UIBarButtonItem {
        control.addTarget(self, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: control)
    }
    
    private func toolButton ( button : ToolButton ) -> UIBarButtonItem {
        button.addTarget(self, action: #selector(onTool(button:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    private func colorButton( color : UIColor , selected : Bool = false) -> UIBarButtonItem {
        let button = ColorSelectorButton()
        button.pathFillColor = color
        button.pathLineWidth = 2.0
        button.addTarget(self, action: #selector(onColor(button:)), for: .touchUpInside)
        button.isSelected = selected
        button.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40.0, height: 40.0))
        
        if selected {
            setToolsColor(color: color)
        }
        
        return UIBarButtonItem(customView: button)
    }
    
    private func setToolsColor( color : UIColor? , isStroke : Bool = true) {
        if let items = navigationController?.toolbar.items {
            items.forEach { if $0.customView?.isKind(of: ToolButton.self) ?? false {
                    if isStroke {
                        ($0.customView as? ToolButton)?.pathFillColor = color
                    } else {
                        ($0.customView as? ToolButton)?.pathStrokeColor = color
                    }
                }
            }
        }
        if isStroke {
            snapshot.graphicProperties.strokeColor = color
        } else {
            snapshot.graphicProperties.fillColor = color
        }
        
    }
    
    // MARK: - UICallback
    
    @objc func onDone() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onTool( button : ToolButton ) {
        guard let items = navigationController?.toolbar.items else { return }
        
        // Toggle
        guard !button.isSelected else {
            button.isSelected = false
            snapshot.currentToolType = nil
            scrollView.isScrollEnabled = true
            snapshot.isUserInteractionEnabled = false
            return
        }
        
        // Toggle the selection
        for item in items {
            if let control = item.customView as? ToolButton,
                control.isSelected {
                control.isSelected = false
                break
            }
        }
        button.isSelected = true
        snapshot.currentToolType = button.toolType
        scrollView.isScrollEnabled = false
        snapshot.isUserInteractionEnabled = true
    }
    
    @objc func onColor( button : ColorSelectorButton? ) {
        
        let controller = ColorSelectorViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.delegate = self
        controller.popoverPresentationController?.sourceView = button
        controller.onColorSelected = {
            [weak self] (color) in
            self?.setToolsColor(color: color)
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    @objc func onLineWidth( button : UIView? ) {
        let controller = LineWidthSelectorViewController()
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.delegate = self
        controller.popoverPresentationController?.sourceView = button
        controller.onLineWidthSelected = {
            [weak self] (lineWidth) in
            self?.snapshot.graphicProperties.lineWidth = lineWidth
        }
        present(controller, animated: true, completion: nil)
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
