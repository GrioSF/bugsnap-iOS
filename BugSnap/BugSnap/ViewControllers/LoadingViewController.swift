//
//  LoadingViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    View Controller for presenting a loading state.
*/
public class LoadingViewController: UIViewController {
    
    // MARK: - Exposed Properties
    
    /// The message to be displayed
    var message : String = ""{
        didSet{
            loadingLabel.text = message
        }
    }
    
    // MARK: - Private UI
    
    /// The content view for the message
    fileprivate let contentView = UIView()
    
    /// the label for the message
    fileprivate let loadingLabel = FieldNameLabel()

    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .crossDissolve
        setup()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.fade(to: UIColor(white: 0.0, alpha: 0.3))
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.fade(to: .clear)
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        
        contentView.backgroundColor = UIColor.white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.cornerRadius = 5.0
        view.addSubview(contentView)
        
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(lessThanOrEqualToConstant: 200.0).isActive = true
        contentView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40.0).isActive = true
        contentView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40.0).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true
        
        loadingLabel.textAlignment = .center
        loadingLabel.numberOfLines = 0
        
        contentView.addSubview(loadingLabel)
        loadingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        loadingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20.0).isActive = true
        loadingLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20.0).isActive = true
        loadingLabel.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor, constant: 20.0).isActive = true
        loadingLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20.0).isActive = true
    }
    


}
