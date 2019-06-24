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
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onShare(item:)))
        shareItem.tintColor = UIColor.white
        navigationItem.setRightBarButton(shareItem, animated: false)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 48, green: 48, blue: 48)

    }
    
    private func setupToolbar() {
        
        let markupButton = MarkupButton()
        markupButton.addTarget(self, action: #selector(onEdit), for: .touchUpInside)
//        let annotationBarButtonItem = UIBarButtonItem(customView: markupButton)
        
//        navigationController?.setToolbarHidden(false, animated: false)
       
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
        let controlller = ShareOptionViewController()
        controlller.modalPresentationStyle = .overCurrentContext
        controlller.optionSelected = {
            [weak self] (option) in
            switch option {
            case .email:
                self?.onShareWithEmail()
            case .jira:
                self?.onShareWithJIRA()
            }
        }
        present(controlller, animated: true, completion: nil)
    }
    
    // MARK: - Presentation Support
    
    private func onShareWithJIRA() {
        
        let jiraLoginViewController = JIRALoginViewController()
        jiraLoginViewController.snapshot = snapshot.image
        
        let navigationController = UINavigationController(rootViewController: jiraLoginViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setToolbarHidden(true, animated: false)
        present(navigationController, animated: true, completion: nil)
        
    }
    
    private func onShareWithEmail() {
        
    }

}
