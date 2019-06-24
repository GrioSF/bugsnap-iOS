//
//  JIRALoginViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/24/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Simple form for signin in to JIRA
*/
class JIRALoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Exposed Properties
    
    /// The snapshot for the issue
    var snapshot : UIImage? = nil
    
    // MARK: - UI Elements
    
    /// The label for the prompt
    fileprivate var promptLabel = UILabel()
    
    /// The field for the user name
    fileprivate var userNameField = PaddedTextField()
    
    /// The field for the api token
    fileprivate var apiTokenField = PaddedTextField()
    
    /// The button for submitting
    fileprivate var submitButton = UIButton()
    
    /// The button for dismissing this view controller
    fileprivate var backButton = UIButton()
    
    /// Whether the resigning first responder comes from user interaction
    fileprivate var keyboardHidingComesFromField = false

    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        buildUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    // MARK: - Build UI
    
    private func buildUI() {
        buildLabel()
        buildUserNameField()
        buildAPITokenField()
        buildSubmitButton()
    }
    
    private func buildLabel() {
        promptLabel.backgroundColor = UIColor.clear
        promptLabel.textColor = UIColor.darkGray
        promptLabel.textAlignment = .center
        promptLabel.numberOfLines = 0
        promptLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.text = "Please enter Jira username\nand API key"
        
        view.addSubview(promptLabel)
        promptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        promptLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        promptLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        promptLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0).isActive = true
    }
    
    private func buildUserNameField() {
        let label = UILabel()
        label.textColor = UIColor(red: 137, green: 137, blue: 137)
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username"
        
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        label.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 30.0).isActive = true
        
        userNameField.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        userNameField.font = label.font
        userNameField.textColor = UIColor.black
        userNameField.textAlignment = .left
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.text = UserDefaults.standard.jiraUserName ?? ""
        userNameField.keyboardType = .emailAddress
        userNameField.autocapitalizationType = .none
        userNameField.textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        userNameField.delegate = self
        
        
        view.addSubview(userNameField)
        userNameField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        userNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        userNameField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        userNameField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3.0).isActive = true
    }
    
    private func buildAPITokenField() {
        let label = UILabel()
        label.textColor = UIColor(red: 137, green: 137, blue: 137)
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "API Key"
        
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        label.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 15.0).isActive = true
        
        apiTokenField.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        apiTokenField.font = label.font
        apiTokenField.textColor = UIColor.black
        apiTokenField.textAlignment = .left
        apiTokenField.translatesAutoresizingMaskIntoConstraints = false
        apiTokenField.text = UserDefaults.standard.jiraApiToken ?? ""
        apiTokenField.autocorrectionType = .no
        apiTokenField.autocapitalizationType = .none
        apiTokenField.textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        apiTokenField.delegate = self
        
        view.addSubview(apiTokenField)
        apiTokenField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        apiTokenField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        apiTokenField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        apiTokenField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3.0).isActive = true
    }
    
    private func buildSubmitButton() {
        submitButton.backgroundColor = UIColor(red: 49, green: 113, blue: 246)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("Confirm", for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.cornerRadius = 2.0
        submitButton.addTarget(self, action: #selector(onConfirm), for: .primaryActionTriggered)
        
        view.addSubview(submitButton)
        submitButton.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15.0 ).isActive = true
    }
    
    // MARK: - UI Callback
    
    @objc func onConfirm() {
        if apiTokenField.text?.count ?? 0 < 1 || userNameField.text?.count ?? 0 < 1 {
            let alert = UIAlertController(title: "Missing information", message: "Both the Username and API Token are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        JIRARestAPI.sharedInstance.setupConnection(userName: userNameField.text ?? "", apiToken: apiTokenField.text ?? "")
        
        let controller = JIRAIssueCreatorViewController()
        controller.snapshot = snapshot
        controller.onDone = {
            [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardHidingComesFromField = true
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if keyboardHidingComesFromField {
            if textField == userNameField {
                apiTokenField.becomeFirstResponder()
            } else {
                onConfirm()
            }
        }
        keyboardHidingComesFromField = false
    }

}
