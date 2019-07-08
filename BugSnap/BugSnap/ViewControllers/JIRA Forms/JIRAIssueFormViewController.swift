//
//  JIRAIssueFormViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/24/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Form for capturing the JIRA Issue data.
    This is a simple form that allows to select the project, the issue type and capture the summary and description.
    No presentation is made about the annotated screenshot.
*/
public class JIRAIssueFormViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Exposed properties
    
    /// The snapshot to be uploaded to JIRA
    var snapshot : UIImage? = nil
    
    // MARK: - UI Controls
    
    /// The scrollview containing all the controls
    fileprivate var scrollView = UIScrollView()
    
    /// The content view for the scroll view
    fileprivate var contentView = UIView()
    
    /// The title for the form
    private var promptLabel = FormTitleLabel(text: "Add Issue Details and Confirm")
    
    /// The view controller for autocomplete
    private var autocomplete = AutocompleteTextFieldViewController()
    
    /// The issue type selector
    private var issueTypeSelector = FormTextField()
    
    /// The summary capture field
    private var summaryField = FormTextField()
    
    /// The description capture field
    private var descriptionField = PaddedTextView()
    
    /// The cancel button
    private var cancelButton = CancelFormButton(title: "Cancel")
    
    /// The confirm button
    private var confirmButton = SubmitFormButton(title: "Add Ticket")
    
    // MARK: - Data Fields
    
    /// The issue type selected
    private var issueTypeSelected : JIRA.Project.IssueType? = nil
    
    /// The issue types associated to this project
    private var issueTypesForProject : [JIRA.Project.IssueType]? = nil
    
    /// A loading view controller
    private weak var loadingViewController : LoadingViewController? = nil
    

    // MARK: - View Life Cycle
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setup()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    
    // MARK: - Build UI
    
    private func setup() {
        setupLowerButtons()
        setupScrollView()
        setupTitle()
        setupProjectField()
        setupIssueType()
        setupSummary()
        setupDescription()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":scrollView]))
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -15.0).isActive = true
        
        // Setup the content view constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.clear
        contentView.isUserInteractionEnabled = true
        scrollView.addSubview(contentView)
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":contentView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":contentView]))
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true
        
    }
    
    private func setupTitle() {
        
        contentView.addSubview(promptLabel)
        promptLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        promptLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        promptLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        promptLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20.0).isActive = true
    }
    
    private func setupProjectField() {
        let label = FieldNameLabel(text: "Project*")
        
        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        label.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 30.0).isActive = true
        
        autocomplete.fieldPlaceholder = ""
        autocomplete.objectLoaderHandler = JIRARestAPI.sharedInstance.allProjects
        autocomplete.onObjectSelected = {
            [weak self] (project) in
            self?.onProjectSelected(project: project)
        }
        autocomplete.view.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        autocomplete.view.translatesAutoresizingMaskIntoConstraints = false
        
        autocomplete.willMove(toParent: self)
        contentView.addSubview(autocomplete.view)
        autocomplete.view.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5.0).isActive = true
        autocomplete.view.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        autocomplete.view.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        autocomplete.view.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        addChild(autocomplete)
        autocomplete.didMove(toParent: self)
    }
    
    private func setupIssueType() {
        let label = FieldNameLabel(text: "Issue Type*")
        
        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        label.topAnchor.constraint(equalTo: autocomplete.view.bottomAnchor, constant: 20.0).isActive = true
        
        issueTypeSelector.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        issueTypeSelector.font = label.font
        issueTypeSelector.textColor = UIColor.black
        issueTypeSelector.textAlignment = .left
        issueTypeSelector.translatesAutoresizingMaskIntoConstraints = false
        issueTypeSelector.text = ""
        issueTypeSelector.isEnabled = false
        issueTypeSelector.placeholder = "Tap to select issue type"
        issueTypeSelector.isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onSelectIssueType))
        issueTypeSelector.addGestureRecognizer(tap)
        
        
        contentView.addSubview(issueTypeSelector)
        issueTypeSelector.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        issueTypeSelector.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        issueTypeSelector.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        issueTypeSelector.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3.0).isActive = true
    }
    
    private func setupSummary() {
        let label = FieldNameLabel(text: "Summary*")
        
        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        label.topAnchor.constraint(equalTo: issueTypeSelector.bottomAnchor, constant: 20.0).isActive = true
        
        summaryField.text = ""
        summaryField.isEnabled = false
        summaryField.keyboardType = .emailAddress
        summaryField.delegate = self
        summaryField.returnKeyType = .continue
        
        contentView.addSubview(summaryField)
        summaryField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        summaryField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        summaryField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        summaryField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3.0).isActive = true
    }
    
    private func setupDescription() {
        let label = FieldNameLabel(text: "Description")
        
        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        label.topAnchor.constraint(equalTo: summaryField.bottomAnchor, constant: 20.0).isActive = true
        
        descriptionField.textInsets = summaryField.textInsets
        descriptionField.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        descriptionField.font = label.font
        descriptionField.textColor = UIColor.black
        descriptionField.textAlignment = .left
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        descriptionField.text = ""
        descriptionField.keyboardType = .asciiCapable
        descriptionField.autocapitalizationType = .none
        descriptionField.isEditable = false
        
        
        contentView.addSubview(descriptionField)
        descriptionField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        descriptionField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        descriptionField.heightAnchor.constraint(equalToConstant: 140.0).isActive = true
        descriptionField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3.0).isActive = true
        
        let toolbar = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        let doneButton = SubmitFormButton(title: "Done")
        doneButton.cornerRadius = 5.0
        doneButton.addTarget(self, action: #selector(onDismissDescription), for: .primaryActionTriggered)
        toolbar.contentView.addSubview(doneButton)
        doneButton.trailingAnchor.constraint(equalTo: toolbar.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20.0).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: toolbar.contentView.centerYAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        
        toolbar.frame = CGRect(x: 0, y: 0, width: 200.0, height: 42.0)
        descriptionField.inputAccessoryView = toolbar
    }
    
    private func setupLowerButtons() {
        
        confirmButton.addTarget(self, action: #selector(onConfirm), for: .primaryActionTriggered)
        
        view.addSubview(confirmButton)
        confirmButton.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15.0 ).isActive = true
        
        cancelButton.addTarget(self, action: #selector(onCancel), for: .primaryActionTriggered)
        
        view.addSubview(cancelButton)
        cancelButton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -30.0).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15.0 ).isActive = true
    }
    
    // MARK: - Data Setup
    
    private func onProjectSelected( project : JIRA.Object? ) {
        guard let jiraProject = project as? JIRA.Project  else { return }
        
        let controller = UIAlertController(title: "Wait a sec...", message: "Loading JIRA's project configuration", preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
        
        JIRARestAPI.sharedInstance.fetchCreateIssueMetadata(project: jiraProject) { [weak self] (issueTypes) in
            controller.dismiss(animated: true, completion: {
                self?.issueTypesForProject = issueTypes
                self?.buildIssueTypeSelector(issueTypes: issueTypes)
            })
        }
    }
    
    // MARK: - Build selection of issue type
    
    private func buildIssueTypeSelector( issueTypes : [JIRA.Project.IssueType]? ) {
        guard let types = issueTypes else { return }
        
        let controller = UIAlertController(title: "Issue Type", message: "Select the issue type", preferredStyle: .alert)
        
        types.forEach {
            let type = $0
            let option = UIAlertAction(title: type.name, style: .default, handler: { [weak self] (_) in
                self?.issueTypeSelected(issueType: type )
                self?.autocomplete.isLocked = true
                self?.summaryField.becomeFirstResponder()
            })
            controller.addAction(option)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
    }
    
    private func issueTypeSelected( issueType : JIRA.Project.IssueType ) {
        issueTypeSelector.isUserInteractionEnabled = true
        issueTypeSelector.text = issueType.name ?? ""
        issueTypeSelected = issueType
        summaryField.isEnabled = true
        descriptionField.isEditable = true
    }
    
    // MARK: - UI Callback
    
    @objc func onSelectIssueType() {
        buildIssueTypeSelector(issueTypes: issueTypesForProject)
    }
    
    @objc func onBack() {
        //navigationController?.popViewController(animated: true)
    }
    
    @objc func onCancel() {
        // TODO: Add confirm
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onDismissDescription() {
        descriptionField.resignFirstResponder()
    }
    
    @objc func onConfirm() {
        
        // hide the keyboard
        view.endEditing(true)
        guard let fields = issueTypeSelected?.fields else {
            presentOperationErrors(errors: ["The issue type doesn't seem to have any fields setup in the metadata. Please select again the issue type."])
            return
        }
        guard let summaryLength = summaryField.text?.trimmingCharacters(in: CharacterSet.whitespaces).count,
            summaryLength > 0 else {
            presentOperationErrors(errors: ["You must capture a non empty summary field"], title: "Missing Data", button: "Ok")
            return
        }
            
        
        loadingViewController = presentLoading(message: "Building issue...")
        
        fields.forEach {
            if ($0.key ?? "") == "summary" && summaryField.text?.count ?? 0 > 0 {
                let value = JIRA.IssueField.Value()
                value.stringValue = summaryField.text
                $0.value = value
            } else if ($0.key ?? "") == "description" && descriptionField.text?.count ?? 0 > 0 {
                let value = JIRA.IssueField.Value()
                value.stringValue = descriptionField.text
                $0.value = value
            }
        }
        
        loadingViewController?.message = "Creating \(issueTypeSelected?.name ?? "Unknown" ) in JIRA"
        
        // TODO: Check if a we're missing a required object
        JIRARestAPI.sharedInstance.createIssue(fields: fields) {
            [weak self] (issue,errors) in
        
            if let errorMessages = errors {
                self?.loadingViewController?.dismiss(animated: true, completion: {
                    self?.presentOperationErrors(errors: errorMessages)
                })
            } else if let issueObject = issue {
                self?.loadingViewController?.message = "Uploading snapshot..."
                self?.uploadImage(issue: issueObject)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let result = textField.text?.trimmingCharacters(in: CharacterSet.whitespaces).count ?? 0 > 0
        
        if result {
            descriptionField.becomeFirstResponder()
        }
        
        return result
    }
    
    // MARK: - Support
    
    /**
        Uploads the annotated snapshot as an attachment.
        - Parameter issue: The issue created previously with the summary and description provided by the UI.
    */
    private func uploadImage( issue : JIRA.Object ) {
        JIRARestAPI.sharedInstance.attach(snapshot: snapshot!, issue: issue) { [weak self] (_, errors) in
            
            self?.loadingViewController?.dismiss(animated: true, completion: {
                
                var block : (()->Void)! // block for preenting after the loading view controller is dismissed
                
                if let messages = errors {
                    block = {
                        self?.presentOperationErrors(errors: messages)
                    }
                } else {
                    block = {
                        self?.showSuccess(issue: issue)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: block)
            })
        }
    }
    
    /**
        Presents an alert letting the user know the process is complete
    */
    private func showSuccess(issue : JIRA.Object) {
        let controller = UIAlertController(title: "Issue created", message: "Issue \(issue.key ?? "") was created successfully!", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            [weak self] (_) in
            // Dismiss this view controller
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                self?.dismiss(animated: true, completion: nil)
            })
        }))
        present(controller, animated: true, completion: nil)
    }
    
    
}
