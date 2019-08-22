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
    
    // MARK: - Constriaints for the scroll view
    
    enum AnchorConstraint : Int {
        case width = 0
        case height = 1
    }
    
    /// The constraints for the scroll view for portrait
    private var scrollViewMarginConstraints = [NSLayoutConstraint]()
    
    
    // MARK: - Exposed Properties
    
    /// The screen snapshot
    var screenSnapshot : UIImage? = nil {
        didSet {
            snapshot.image = screenSnapshot
        }
    }
    
    /// The handler when the edition has finished
    var onEditionFinished : ((UIImage?)->Void)? = nil
    
    /// Whether it should display the share button
    var shouldDisplayShare = true

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
            self?.dismissPreviousToolOptions(isDocking: true)
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
        setupScrollViewConstraints(size: view.bounds.size)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.snapshot.alpha = 1.0
        }) { (_) in
            self.setupMinimumZoomScale( animated: true)
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    // MARK: - Rotation Management
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
        setupScrollViewConstraints(size: size)
        view.setNeedsLayout()
        coordinator .animate(alongsideTransition: { (_) in
            self.view.layoutIfNeeded()
        }) { (_) in
            self.setupScrollViewConstraints(size: size)
            self.view.setNeedsLayout()
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.setupMinimumZoomScale(animated: true)
            })
        }
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
        if shouldDisplayShare {
            let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onShare(item:)))
            shareItem.tintColor = UIColor.white
            navigationItem.setRightBarButton(shareItem, animated: false)
        } else {
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone(item:)))
            doneItem.tintColor = UIColor.white
            navigationItem.setRightBarButton(doneItem, animated: false)
        }
        
        // Setup the dismiss button
        navigationItem.setLeftBarButton(customViewControl(control: DismissButton(), selector: #selector(onDismiss)), animated: false)
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        let window = UIApplication.shared.keyWindow!
        
        scrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        scrollViewMarginConstraints.append(contentsOf: [
            scrollView.widthAnchor.constraint(equalToConstant: 100.0),
            scrollView.heightAnchor.constraint(equalToConstant: 100.0)
            ])

        scrollView.maximumZoomScale = UIScreen.main.scale
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.canCancelContentTouches = false
        scrollView.delaysContentTouches = false
        scrollView.insetsLayoutMarginsFromSafeArea = false
        scrollView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        scrollView.cornerRadius = 5.0
        
        setupScrollViewConstraints(size: window.bounds.size)
    }
    
    private func setupScrollViewConstraints( size : CGSize ) {
        
        scrollViewMarginConstraints.forEach { $0.isActive = true }
        
        var windowSize = UIApplication.shared.keyWindow!.bounds.size
        var width = size.width
        if size.width > size.height {
            if windowSize.width < windowSize.height {
                windowSize = CGSize(width: windowSize.height, height: windowSize.width)
            }
            width = width - 120.0 - view.safeAreaInsets.left - view.safeAreaInsets.right
        } else {
            if windowSize.height < windowSize.width {
                windowSize = CGSize(width: windowSize.height, height: windowSize.width)
            }
            width = width - 100.0
        }
        
        
        scrollViewMarginConstraints[AnchorConstraint.width.rawValue].constant = width
        scrollViewMarginConstraints[AnchorConstraint.height.rawValue].constant = width * windowSize.height / windowSize.width
        view.setNeedsUpdateConstraints()
        view.setNeedsLayout()
    }
    
    private func setupImageView() {
        snapshot.contentMode = .center
        snapshot.translatesAutoresizingMaskIntoConstraints = false
        snapshot.scrollView = scrollView
        scrollView.addSubview(snapshot)
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[snapshot]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["snapshot":snapshot]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[snapshot]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["snapshot":snapshot]))
        snapshot.alpha = 0.0
    }
    
    private func setupMinimumZoomScale( animated : Bool = false) {
        let minimumScale = min(scrollView.bounds.width/snapshot.image!.size.width,scrollView.bounds.height/snapshot.image!.size.height)
        scrollView.minimumZoomScale = minimumScale
        scrollView.setZoomScale(minimumScale, animated: animated)
    }
    
    private func setupToolbar() {
        let strokeButton = DrawToolButton()
        let textButton = TextToolButton()
        let shapesButton = ShapesToolButton()
        let trashButton = TrashToolButton()
        
        toolbarButtons.removeAll()
        toolbarButtons.append(contentsOf: [strokeButton,textButton,shapesButton,trashButton])
        toolbarButtons.forEach {
            $0.isSelected = false
        }
        
        navigationController?.toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                                customViewControl(control: strokeButton, selector: #selector(onStroke(button:))),
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                                customViewControl(control: textButton, selector: #selector(onText(button:))),
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                                customViewControl(control: shapesButton, selector: #selector(onShapes(button:))),
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                                                customViewControl(control: trashButton, selector: #selector(onTrash(button:))),
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            ], animated: true)
        
        snapshot.onShapeSelectionChanged = {
            (somethingSelected) in
            trashButton.isSelected = somethingSelected
        }
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
    
    @objc func onTrash( button : ToolbarSelectableButton ) {
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
            self?.snapshot.graphicProperties.lineWidth = 5.0
            self?.snapshot.currentToolType = shapeType
        }
        snapshot.autoDeselect = false
    }
   
    
    @objc func onShare( item : UIBarButtonItem? ) {
        let loading = self.navigationController?.presentLoading(message: "Generating image...")
        snapshot.snapshot { [weak self] (newImage) in
            loading?.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    self?.startJIRACapture(snapshot: newImage)
                })
            })
        }
    }
    
    @objc func onDone( item : UIBarButtonItem? ) {
        let loading = self.navigationController?.presentLoading(message: "Generating image...")
        snapshot.snapshot { [weak self] (newImage) in
            loading?.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    self?.onEditionFinished?(newImage)
                })
            })
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return snapshot
    }

    
    // MARK: - Presentation Support
    
    private func handleToolAction(button : ToolbarSelectableButton, optionsController : ToolOptionsViewController ) {
        
        guard !button.isSelected else {
            
            if let menu = currentMenuController {
                menu.isDocked = !menu.isDocked
                
            // For some reason the menu is not available, show it again
            } else {
                showToolsOptionsController(optionsController: optionsController)
            }
            
            return
        }
        
        if lastToolSelected != nil {
            lastToolSelected?.isSelected = false
            dismissPreviousToolOptions()
        }
        button.isSelected = true
        lastToolSelected = button
        showToolsOptionsController(optionsController: optionsController)
    }
    
    private func showToolsOptionsController( optionsController : ToolOptionsViewController ) {
        guard currentMenuController == nil else { return }
        optionsController.show(parent: self)
        currentMenuController = optionsController
        
        // Handle the color change which is generic
        optionsController.onColorSelectedHandler =  {
            [weak self] (color) in
            self?.snapshot.graphicProperties.strokeColor = color
        }
        optionsController.colorSelected = snapshot.graphicProperties.strokeColor ?? UIColor(red: 0, green: 0, blue: 0)
    }
    
    private func dismissPreviousToolOptions( isDocking : Bool = false) {
        if let controller = currentMenuController {
            if isDocking {
                controller.isDocked = true
            } else {
                controller.hide()
                currentMenuController = nil
            }
        }
    }
}
