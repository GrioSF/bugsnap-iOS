//
//  SnapshotViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import UIKit

/**
    The main view controller containing the snapshot of the current screen.
*/
public class SnapshotViewController: UIViewController {
    
    // MARK: - Exposed Properties
    
    /// The screen capture passed to this view controller
    var screenCapture : UIImage? = nil
    
    // MARK: - UI Properties
    
    /// The image view for the snapshot
    private var snapshot = UIImageView()

    // MARK: - UIView Life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupNavigationBar()
        setupSnapshot()
    }
    
    private func setupNavigationBar() {
        
        // Setup the title and the buttons
        title = "Report Bug 🐞"
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone)), animated: false)
        
        let markupButton = MarkupButton()
        markupButton.addTarget(self, action: #selector(onEdit), for: .touchUpInside)
        let annotationBarButtonItem = UIBarButtonItem(customView: markupButton)
        navigationItem.setRightBarButton(annotationBarButtonItem, animated: false)
    }
    
    private func setupSnapshot() {
        
        // Setup the snapshot
        view.addSubview(snapshot)
        snapshot.image = screenCapture
        snapshot.contentMode = .scaleAspectFit
        snapshot.translatesAutoresizingMaskIntoConstraints = false
        snapshot.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        snapshot.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        snapshot.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        snapshot.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - Callback
    
    @objc func onDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onEdit() {
        let controller = MarkupEditorViewController()
        controller.screenSnapshot = snapshot.image
        controller.onEditionFinished = {
            [weak self] (editedImage) in
            self?.snapshot.image = editedImage
        }
        navigationController?.pushViewController(controller, animated: true)
    }

}
