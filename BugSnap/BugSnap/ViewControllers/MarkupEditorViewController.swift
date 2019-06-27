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
    private var scrollView = ShapeEditorScrollView()
    
    /// The content view for the scroll view
    private var snapshot = ShapesView()
    
    /// The current menu for a tool
    private weak var currentMenuController : ToolOptionsViewController?
    
    /// The buttons present in the toolbar
    private var toolbarButtons = [ToolbarSelectableButton]()
    
    /// The last tool selected
    private var lastToolSelected : ToolbarSelectableButton? = nil
    
    /// The brush size
    private var brushSize = CGFloat(1.0)
    
    // MARK: - View Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        snapshot.graphicProperties.strokeColor = UIColor(red: 0, green: 0, blue: 0)
        snapshot.graphicProperties.lineWidth = 1.0
        snapshot.image = screenSnapshot ?? UIImage(named: "TestImage")
        snapshot.onEndedGesture = {
            [weak self] (autoDeselected) in
            
            if autoDeselected {
                self?.snapshot.currentToolType = nil
                self?.lastToolSelected?.isSelected = false
                self?.dismissPreviousToolOptions()
            }
        }
        snapshot.onBeganGesture = {
            [weak self] in
            self?.dismissPreviousToolOptions()
        }
        //scrollView.isScrollEnabled = false
        snapshot.isUserInteractionEnabled = true
        setup()
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.toolbar.isTranslucent = false
        navigationController?.toolbar.barStyle = .default
        navigationController?.toolbar.barTintColor = navigationController?.navigationBar.barTintColor
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
        
        // Setup the navigation bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 48, green: 48, blue: 48)
        
        // Setup the right buttom item
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onShare(item:)))
        shareItem.tintColor = UIColor.white
        navigationItem.setRightBarButton(shareItem, animated: false)
        
        // Setup the dismiss button
        navigationItem.setLeftBarButton(customViewControl(control: DismissButton(), selector: #selector(onDismiss)), animated: false)
        navigationController?.setToolbarHidden(false, animated: false)
        
        let trashButton = TrashButton()
        trashButton.addTarget(self, action: #selector(onTrash), for: .touchUpInside)
        navigationItem.titleView = trashButton
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.maximumZoomScale = UIScreen.main.scale
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.canCancelContentTouches = false
        scrollView.delaysContentTouches = false
    }
    
    private func setupImageView() {
        snapshot.contentMode = .center
        snapshot.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(snapshot)
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[snapshot]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["snapshot":snapshot]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[snapshot]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["snapshot":snapshot]))
    }
    
    private func setupToolbar() {
        guard toolbarButtons.count == 0 else { return }
        
        let strokeButton = DrawToolButton()
        let textButton = TextToolButton()
        let shapesButton = ShapesToolButton()
        
        toolbarButtons.append(contentsOf: [strokeButton,textButton,shapesButton])
        toolbarButtons.forEach {
            $0.isSelected = false
        }
        
        navigationController?.toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                                customViewControl(control: strokeButton, selector: #selector(onStroke(button:))),
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                                customViewControl(control: textButton, selector: #selector(onText(button:))),
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                                customViewControl(control: shapesButton, selector: #selector(onShapes(button:))),
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            ], animated: true)
    }
    
    private func customViewControl( control : UIControl, selector : Selector ) -> UIBarButtonItem {
        control.addTarget(self, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: control)
    }
    
    
    // MARK: - Support
    
    
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
            self.snapshot.autoDeselect = true
        }))
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - UICallback
    
    @objc func onDismiss() {
        scrollView.isUserInteractionEnabled = false
        snapshot.snapshot { [weak self] (image) in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func onTrash() {
        
    }
    
    @objc func onStroke( button : ToolbarSelectableButton) {
        let controller = StrokeOptionsViewController()
        handleToolAction(button: button, optionsController: controller)
        
        controller.lineWidth = brushSize
        controller.onLineWidthChangedHandler = {
            [weak self] (lineWidth) in
            self?.brushSize = lineWidth
            self?.snapshot.graphicProperties.lineWidth = lineWidth
        }
        
        snapshot.currentToolType = StrokeShape.self
        snapshot.autoDeselect = false
        
    }
    
    @objc func onText( button : ToolbarSelectableButton ) {
        handleToolAction(button: button, optionsController: StrokeOptionsViewController())
        
        snapshot.currentToolType = nil
        snapshot.autoDeselect = true
    }
    
    @objc func onShapes( button : ToolbarSelectableButton ) {
        let controller = ShapesOptionsViewController()
        handleToolAction(button: button, optionsController: controller)
        
        controller.onShapeSelectedHandler = {
            [weak self] (shapeType) in
            self?.snapshot.graphicProperties.lineWidth = 2.0
            self?.snapshot.currentToolType = shapeType
            self?.snapshot.autoDeselect = true
        }
    }
   
    
    @objc func onShare( item : UIBarButtonItem? ) {
        onShareWithJIRA()
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return snapshot
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    // MARK: - Presentation Support
    
    private func handleToolAction(button : ToolbarSelectableButton, optionsController : ToolOptionsViewController ) {
        
        guard !button.isSelected else {
            if currentMenuController == nil {
                showToolsOptionsController(optionsController: optionsController)
            } else {
                dismissPreviousToolOptions()
            }
            return
        }
        dismissPreviousToolOptions()
        if lastToolSelected != nil {
            lastToolSelected?.isSelected = false
        }
        button.isSelected = true
        lastToolSelected = button
        showToolsOptionsController(optionsController: optionsController)
    }
    
    private func showToolsOptionsController( optionsController : ToolOptionsViewController ) {
        optionsController.show(parent: self)
        currentMenuController = optionsController
        
        // Handle the color change which is generic
        optionsController.onColorSelectedHandler =  {
            [weak self] (color) in
            self?.snapshot.graphicProperties.strokeColor = color
        }
        optionsController.colorSelected = snapshot.graphicProperties.strokeColor ?? UIColor(red: 0, green: 0, blue: 0)
    }
    
    private func dismissPreviousToolOptions() {
        if let controller = currentMenuController {
            controller.hide()
        }
    }
    
    private func onShareWithJIRA() {
        let loading = self.navigationController?.presentLoading(message: "Generating image...")
        snapshot.snapshot { [weak self] (newImage) in
            loading?.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    self?.presentJIRACapture(image: newImage)
                })
            })
        }
    }
    
    private func onShareWithEmail() {
        
    }
    
    private func presentJIRACapture( image : UIImage? ) {
        let jiraLoginViewController = JIRALoginViewController()
        jiraLoginViewController.snapshot = image
        
        let navigationController = UINavigationController(rootViewController: jiraLoginViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setToolbarHidden(true, animated: false)
        present(navigationController, animated: true, completion: nil)
    }
}
