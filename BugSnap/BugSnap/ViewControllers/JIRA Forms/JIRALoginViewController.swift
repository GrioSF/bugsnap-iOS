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
    
    /// The handler if the login process was successful
    var onSuccess : (()->Void)? = nil
    
    // MARK: - UI Elements
    
    /// The label for the prompt
    fileprivate var promptLabel = FormTitleLabel(text: "Please enter Jira username\nand API key")
    
    /// The field for the user name
    fileprivate var userNameField = FormTextField()
    
    /// The field for the api token
    fileprivate var apiTokenField = FormTextField()
    
    /// The button for submitting
    fileprivate var submitButton = SubmitFormButton(title: "Confirm")
    
    /// The button for cancelling
    fileprivate var cancelButton = CancelFormButton(title: "Cancel")
    
    /// The button for dismissing this view controller
    fileprivate var backButton = UIButton()
    
    /// Whether the resigning first responder comes from user interaction
    fileprivate var keyboardHidingComesFromField = false
    
    /// Whether the login process was successful
    fileprivate var loginSuccessful = false

    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //view.fade(to: UIColor(white: 0.0, alpha: 0.3))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        //view.fade(to: .clear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if loginSuccessful {
            onSuccess?()
        }
    }
    
    // MARK: - Build UI
    
    private func buildUI() {
        buildLabel()
        buildUserNameField()
        buildAPITokenField()
        buildSubmitButton()
        buildCancelButton()
    }
    
    private func buildLabel() {
        
        view.addSubview(promptLabel)
        promptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        promptLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        promptLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        promptLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0).isActive = true
    }
    
    private func buildUserNameField() {
        
        let label = FieldNameLabel(text: "Username")
        
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        label.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 30.0).isActive = true
        
        userNameField.text = UserDefaults.standard.jiraUserName ?? ""
        userNameField.keyboardType = .emailAddress
        userNameField.autocapitalizationType = .none
        userNameField.delegate = self
        
        view.addSubview(userNameField)
        userNameField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        userNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        userNameField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        userNameField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3.0).isActive = true
    }
    
    private func buildAPITokenField() {
        
        let label = FieldNameLabel(text: "API Key")
        
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        label.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 15.0).isActive = true
        
        apiTokenField.text = UserDefaults.standard.jiraApiToken ?? ""
        apiTokenField.autocorrectionType = .no
        apiTokenField.autocapitalizationType = .none
        apiTokenField.delegate = self
        
        view.addSubview(apiTokenField)
        apiTokenField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        apiTokenField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        apiTokenField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        apiTokenField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3.0).isActive = true
    }
    
    private func buildSubmitButton() {
        submitButton.addTarget(self, action: #selector(onConfirm), for: .primaryActionTriggered)
        
        view.addSubview(submitButton)
        submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -20.0).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15.0 ).isActive = true
    }
    
    private func buildCancelButton() {
        cancelButton.addTarget(self, action: #selector(onCancel), for: .primaryActionTriggered)
        
        view.addSubview(cancelButton)
        cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: submitButton.leadingAnchor, constant: -10.0).isActive = true
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
        let loadingController = presentLoading(message: "Wait a sec, authenticating...")
        JIRARestAPI.sharedInstance.pingProjectCall {
            [weak self] (messages) in
            loadingController.dismiss(animated: true, completion: {
                if let errors = messages, errors.count > 0 {
                    self?.presentOperationErrors(errors: errors, title: "Review your credentails")
                } else {
                    self?.loginSuccessful = true
                    self?.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    @objc func onCancel() {
        dismiss(animated: true, completion: nil)
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
