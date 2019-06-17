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
    
    /// The handler when the edition has finished
    var onEditionFinished : ((UIImage?)->Void)? = nil

    // MARK: - UI Properties
    
    /// The scroll view to support zooming into the image
    private var scrollView = UIScrollView()
    
    /// The content view for the scroll view
    private var snapshot = ShapesView()
    
    /// The undo button for enabling it or disable it
    private var undoButton : UndoButton!
    
    // MARK: - View Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        snapshot.image = screenSnapshot ?? UIImage(named: "TestImage")
        snapshot.onEndedGesture = {
            [weak self] (autoDeselected) in
            
            if autoDeselected {
                self?.scrollView.isScrollEnabled = true
                self?.snapshot.isUserInteractionEnabled = false
                // Reset the auto deselection whenever this is called.
                self?.snapshot.autoDeselect = false
            }
            self?.undoButton.isEnabled = self?.snapshot.isDirty ?? false
            
        }
        setup()        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        undoButton.isEnabled = snapshot.isDirty
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
        undoButton = UndoButton()
        let undoButtonItem = customViewControl(control: undoButton, selector: #selector(onUndo(button:)))
        navigationItem.setLeftBarButton(doneButton, animated: false)
        navigationItem.setRightBarButton(undoButtonItem, animated: false)
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
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                                customViewControl(control: LineWidthSelectorButton(), selector: #selector(onLineWidth(button:))),
                                                customViewControl(control: StrokeColorSelectorButton(), selector: #selector(onStrokeColor(button:))),
                                                customViewControl(control: ColorSelectorButton(), selector: #selector(onFillColor(button:))),
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                                customViewControl(control: ShapeSelectorButton(), selector: #selector(onShapeTools(button:)))
            ], animated: true)
        setToolsColor(color: UIColor.red, isStroke: true)
        setToolsColor(color: nil, isStroke: false)
    }
    
    private func customViewControl( control : UIControl, selector : Selector ) -> UIBarButtonItem {
        control.addTarget(self, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: control)
    }
    
    private func toolButton ( button : ToolButton ) -> UIBarButtonItem {
        button.addTarget(self, action: #selector(onTool(button:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    private func setToolsColor( color : UIColor? , isStroke : Bool = true) {
        if let items = navigationController?.toolbar.items {
            items.forEach { if $0.customView?.isKind(of: ToolButton.self) ?? false {
                    if isStroke {
                        ($0.customView as? ToolButton)?.pathStrokeColor = color
                    } else {
                        ($0.customView as? ToolButton)?.pathFillColor = color
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
    
    // MARK: - Support
    
    private func deselectToolbarTools() {
        guard let items = navigationController?.toolbar.items else { return }
        
        // Toggle the selection
        for item in items {
            if let control = item.customView as? ToolButton,
                control.isSelected {
                control.isSelected = false
                break
            }
        }
    }
    
    private func captureTextToolText() {
        let controller = UIAlertController(title: "Text Tool", message: "Enter your text", preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.text = "Text"
            textField.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
            
        }
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (_) in
            self.snapshot.currentToolType = nil
        }))
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = controller.textFields?.first!
            self.snapshot.currentText = textField?.text
            self.deselectToolbarTools()
            self.scrollView.isScrollEnabled = false
            self.snapshot.isUserInteractionEnabled = true
            self.snapshot.autoDeselect = true
        }))
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - UICallback
    
    @objc func onDone() {
        scrollView.isUserInteractionEnabled = false
        snapshot.snapshot { [weak self] (image) in
            self?.onEditionFinished?(image)
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func onUndo( button : PathBasedButton ) {
        button.isEnabled = snapshot.undo()
    }
    
    @objc func onTool( button : ToolButton ) {
        
        // Toggle
        guard !button.isSelected else {
            button.isSelected = false
            snapshot.currentToolType = nil
            scrollView.isScrollEnabled = true
            snapshot.isUserInteractionEnabled = false
            return
        }
        
        // Select this tool
        deselectToolbarTools()
        button.isSelected = true
        snapshot.currentToolType = button.toolType
        scrollView.isScrollEnabled = false
        snapshot.isUserInteractionEnabled = true
    }
    
    @objc func onStrokeColor( button : StrokeColorSelectorButton? ) {
        let controller = ColorSelectorViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.delegate = self
        controller.popoverPresentationController?.sourceView = button
        controller.onColorSelected = {
            [weak self] (color) in
            button?.pathFillColor = color
            self?.setToolsColor(color: color, isStroke: true)
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    @objc func onFillColor( button : ColorSelectorButton? ) {
        
        let controller = ColorSelectorViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.delegate = self
        controller.popoverPresentationController?.sourceView = button
        controller.onColorSelected = {
            [weak self] (color) in
            button?.pathFillColor = color
            self?.setToolsColor(color: color, isStroke: false)
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
    
    @objc func onShapeTools( button : UIView? ) {
        let controller = ShapeToolViewController()
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.delegate = self
        controller.popoverPresentationController?.sourceView = button
        controller.graphicProperties = snapshot.graphicProperties
        controller.onToolSelected = {
            [weak self] (toolType) in
            self?.deselectToolbarTools()
            self?.snapshot.currentToolType = toolType
            
            if toolType == TextShape.self {
                self?.captureTextToolText()
            } else {
                self?.scrollView.isScrollEnabled = false
                self?.snapshot.isUserInteractionEnabled = true
                self?.snapshot.autoDeselect = true
            }
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
