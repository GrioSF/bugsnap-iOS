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
public class MarkupEditorViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    // MARK: - Exposed Properties
    
    /// The screen snapshot
    var screenSnapshot : UIImage? = nil {
        didSet {
            snapshot.image = screenSnapshot
        }
    }
    
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
    
    /// The constraints for the scroll view for portrait
    private var portraitConstraints = [NSLayoutConstraint]()
    
    /// The constraints for the scroll view for landscape
    private var landscapeConstraints = [NSLayoutConstraint]()
    
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
        navigationController?.hidesBottomBarWhenPushed = false
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: animated)
        view.backgroundColor = UIColor(red: 192, green: 192, blue: 192)
        navigationController?.view.backgroundColor = view.backgroundColor
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupToolbar()
        setupMinimumZoomScale()
        UIView.animate(withDuration: 0.3) {
            self.snapshot.alpha = 1.0
        }
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
        
        let window = UIApplication.shared.keyWindow!
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40.0).isActive = true
        scrollView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        portraitConstraints.append(contentsOf: [
            scrollView.widthAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: window.bounds.width/window.bounds.height)
            ])
        
        landscapeConstraints.append(contentsOf: [
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
            ])

        scrollView.maximumZoomScale = UIScreen.main.scale
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.canCancelContentTouches = false
        scrollView.delaysContentTouches = false
        scrollView.insetsLayoutMarginsFromSafeArea = false
        
        if let window = UIApplication.shared.keyWindow,
            window.bounds.width > window.bounds.height {
            landscapeConstraints.forEach { $0.isActive = true }
        } else {
            portraitConstraints.forEach { $0.isActive = true }
        }
    }
    
    private func setupImageView() {
        snapshot.contentMode = .center
        snapshot.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(snapshot)
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[snapshot]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["snapshot":snapshot]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[snapshot]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["snapshot":snapshot]))
        snapshot.alpha = 0.0
    }
    
    private func setupMinimumZoomScale() {
        let minimumScale = min(scrollView.bounds.width/snapshot.image!.size.width,scrollView.bounds.height/snapshot.image!.size.height)
        scrollView.minimumZoomScale = minimumScale
        scrollView.setZoomScale(minimumScale, animated: false)
    }
    
    private func setupToolbar() {
        let strokeButton = DrawToolButton()
        let textButton = TextToolButton()
        let shapesButton = ShapesToolButton()
        
        toolbarButtons.removeAll()
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
    
    
    // MARK: - UICallback
    
    @objc func onDismiss() {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func onTrash() {
        snapshot.deleteSelectedShape()
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
        let controller = TextOptionsViewController()
        handleToolAction(button: button, optionsController: controller)
        
        controller.fontSize = snapshot.graphicProperties.fontSize
        controller.onFontSizeChangedHandler = {
            [weak self] (fontSize) in
            self?.snapshot.graphicProperties.fontSize = fontSize
        }
        
        snapshot.currentToolType = TextShape.self
        snapshot.autoDeselect = true
    }
    
    @objc func onShapes( button : ToolbarSelectableButton ) {
        let controller = ShapesOptionsViewController()
        handleToolAction(button: button, optionsController: controller)
        
        controller.onShapeSelectedHandler = {
            [weak self] (shapeType) in
            self?.snapshot.graphicProperties.lineWidth = 2.0
            self?.snapshot.currentToolType = shapeType
        }
        snapshot.autoDeselect = false
    }
   
    
    @objc func onShare( item : UIBarButtonItem? ) {
        let loading = self.navigationController?.presentLoading(message: "Generating image...")
        snapshot.snapshot { [weak self] (newImage) in
            loading?.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    self?.presentJIRACapture(image: newImage)
                })
            })
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
    
    private func presentJIRACapture( image : UIImage? ) {
        let jiraLoginViewController = JIRALoginViewController()
        jiraLoginViewController.modalPresentationStyle = .overCurrentContext
        jiraLoginViewController.modalTransitionStyle = .coverVertical
        present(jiraLoginViewController, animated: true, completion: nil)
        
        jiraLoginViewController.onSuccess = {
            [weak self] in
            
            let controller = JIRAIssueFormViewController()
            controller.snapshot = image
            controller.modalTransitionStyle = .crossDissolve
            self?.present(controller, animated: true, completion: nil)
        }
    }
}
