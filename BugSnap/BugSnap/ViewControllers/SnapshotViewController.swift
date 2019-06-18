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
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupToolbar()
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
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupToolbar() {
        navigationController?.setToolbarHidden(false, animated: false)
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onShare(item:)))
        navigationController?.toolbar.setItems([shareItem,
                                                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            ], animated: true)
    }
    
    private func setupSnapshot() {
        
        // Setup the snapshot
        view.addSubview(snapshot)
        snapshot.backgroundColor = UIColor.black
        snapshot.image = screenCapture
        snapshot.contentMode = .scaleAspectFit
        snapshot.translatesAutoresizingMaskIntoConstraints = false
        snapshot.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        snapshot.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        snapshot.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        snapshot.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
    
    @objc func onShare( item : UIBarButtonItem? ) {
   
        let controller = UIAlertController(title: "Permissions", message: "TODO: Require verify permissions!!", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
        /*
        let controller = UIActivityViewController(activityItems: [snapshot.image!], applicationActivities: nil)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            controller.popoverPresentationController?.barButtonItem = item
            controller.modalPresentationStyle = .popover
        }
        present(controller, animated: true, completion: nil)
         */
        
        //JIRARestAPI.login(username: "hgarcia@grio.com", password: "Ullman2017")
        //JIRARestAPI.allProjects()
        /*
         */
    }

}
