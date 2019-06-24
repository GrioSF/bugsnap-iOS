//
//  ShareOptionViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/24/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/// Options for sharing the bug report
enum ShareOption {
    
    /// Share by email
    case email
    
    /// Share by JIRA
    case jira
}

/**
    View Controller to present the share option
*/
class ShareOptionViewController: UIViewController {
    
    // MARK: - UI Elements
    
    /// The background view for these options
    private let fxView = UIVisualEffectView(effect: UIBlurEffect(style: .dark) )
    
    /// The label with the export legend
    private let exportToLabel = UILabel()
    
    /// The button with the email option
    private let toEmailButton = UILabel()
    
    /// The button with the jira option
    private let toJiraButton = UILabel()
    
    /// The cancel button
    private let cancelButton = UIButton()
    
    /// The option selected
    private var option : ShareOption? = nil
    
    // MARK: - Callback
    
    /// The handler for the option selected
    var optionSelected : ((ShareOption)->Void)? = nil
    
    // MARK: - View Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if option != nil {
            optionSelected?(option!)
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupBackgroundView()
        setupCancelButton()
        setupJira()
        setupEmail()
        setupExportLabel()
    }
    
    private func setupBackgroundView() {
        view.addSubview(fxView)
        fxView.translatesAutoresizingMaskIntoConstraints = false
        fxView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        fxView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        fxView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        fxView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupExportLabel() {
        exportToLabel.textColor = UIColor.white
        exportToLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        exportToLabel.text = "Export to : "
        exportToLabel.textAlignment = .left
        exportToLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(exportToLabel)
        exportToLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        exportToLabel.bottomAnchor.constraint(equalTo: toEmailButton.topAnchor, constant: 0.0).isActive = true
        exportToLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        underline(container: exportToLabel)
    }
    
    private func setupEmail() {
    
        toEmailButton.textColor = UIColor.white
        toEmailButton.font =  UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        toEmailButton.tintColor = UIColor.white
        toEmailButton.textAlignment = .left
        toEmailButton.translatesAutoresizingMaskIntoConstraints = false
        toEmailButton.isUserInteractionEnabled = true
        toEmailButton.text = "Email"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onEmail))
        toEmailButton.addGestureRecognizer(tap)
        
        view.addSubview(toEmailButton)
        toEmailButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        toEmailButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        toEmailButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        toEmailButton.bottomAnchor.constraint(equalTo: toJiraButton.topAnchor).isActive = true
        
        underline(container: toEmailButton)
    }
    
    private func setupJira() {
        
        toJiraButton.textColor = UIColor.white
        toJiraButton.font =  UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        toJiraButton.tintColor = UIColor.white
        toJiraButton.text = "Jira"
        toJiraButton.textAlignment = .left
        toJiraButton.translatesAutoresizingMaskIntoConstraints = false
        toJiraButton.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onJira))
        toJiraButton.addGestureRecognizer(tap)
        
        view.addSubview(toJiraButton)
        toJiraButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        toJiraButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -60.0).isActive = true
        toJiraButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        toJiraButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
        
        underline(container: toJiraButton)
    }
    
    private func underline( container : UIView) {
        let line = UIView()
        line.backgroundColor = UIColor.white
        line.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(line)
        line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        line.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        line.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 0.0).isActive = true
    }
    
    private func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(onCancel), for: .primaryActionTriggered)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font =  UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        cancelButton.tintColor = UIColor.white
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cancelButton)
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    // MARK: - UI Callback
    
    @objc func onEmail() {
        option = .email
        onCancel()
    }
    
    @objc func onJira() {
        option = .jira
        onCancel()
    }
    
    @objc func onCancel() {
        dismiss(animated: true, completion: nil)
    }

}
