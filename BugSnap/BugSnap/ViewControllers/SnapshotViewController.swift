//
//  SnapshotViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
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
        title = "🐞 Bug Snapped! "
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone)), animated: false)
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(onEdit)), animated: false)
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
        let activityController = UIActivityViewController(activityItems: [screenCapture!], applicationActivities: nil)

        
        present(activityController, animated: true, completion: nil)
    }

}
