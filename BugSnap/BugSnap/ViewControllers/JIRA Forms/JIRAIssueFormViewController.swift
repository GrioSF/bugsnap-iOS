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
public class JIRAIssueFormViewController: ScrolledViewController, UITextFieldDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Exposed properties
    
    /// The snapshot to be uploaded to JIRA
    var snapshot : UIImage? = nil
    
    /// The video URL for uploading to JIRA
    var videoURL : URL? = nil
    
    // MARK: - UI Controls
    
    /// The title for the form
    private var promptLabel = FormTitleLabel(text: "Add Issue Details and Confirm")
    
    /// The view controller for autocomplete
    private var autocomplete = AutocompleteTextFieldViewController()
    
    /// The issue type selector
    private var issueTypeSelector = FormTextField()
    
    /// The issue type selector touches interceptor
    private var issueTypeSelectorTouchInterceptor = UIView()
    
    /// The summary capture field
    private var summaryField = FormTextField()
    
    /// The description capture field
    private var descriptionField = UITextView()
    
    /// The toggle for the log file
    private var checkboxLog = CheckboxControl(label: "Log Attached")
    
    /// The toggle for the media file
    private var checkboxMedia : CheckboxControl!
    
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
        setupMediaAttachmentToggles()
    }
    
    private func setupTitle() {
        
        // Add the separator with shadow to the title
        let separator = UIView()
        separator.backgroundColor = UIColor.white
        separator.layer.shadowColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        separator.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        separator.layer.shadowRadius = 3.0
        separator.layer.shadowOpacity = 0.8
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(separator)
        separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        contentView.addSubview(promptLabel)
        promptLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        promptLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        promptLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        promptLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0.0 ).isActive = true
        promptLabel.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        separator.bottomAnchor.constraint(equalTo: promptLabel.bottomAnchor).isActive = true
        
        // Add the back button
        let back = ChevronLeftButton()
        back.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(back)
        back.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0).isActive = true
        back.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor).isActive = true
        back.widthAnchor.constraint(equalToConstant: 36.0).isActive = true
        back.heightAnchor.constraint(equalTo: back.widthAnchor).isActive = true
        back.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
    }
    
    private func setupScrollView() {
        
        view.removeConstraint(bottomConstraint!)
        scrollView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -15.0).isActive = true
        view.setNeedsUpdateConstraints()
        view.setNeedsLayout()
    }
    
    private func setupProjectField() {
        let label = FieldNameLabel(text: "Project*")
        
        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        label.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 30.0).isActive = true
        
        autocomplete.fieldPlaceholder = ""
        autocomplete.objectLoaderHandler = JIRARestAPI.sharedInstance.allProjects
        autocomplete.preloadedObjectKey = UserDefaults.standard.jiraProject
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
        
        contentView.addSubview(issueTypeSelector)
        issueTypeSelector.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        issueTypeSelector.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        issueTypeSelector.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        issueTypeSelector.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3.0).isActive = true
        
        issueTypeSelectorTouchInterceptor.backgroundColor = UIColor.clear
        issueTypeSelectorTouchInterceptor.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(issueTypeSelectorTouchInterceptor)
        issueTypeSelectorTouchInterceptor.leadingAnchor.constraint(equalTo: issueTypeSelector.leadingAnchor).isActive = true
        issueTypeSelectorTouchInterceptor.trailingAnchor.constraint(equalTo: issueTypeSelector.trailingAnchor).isActive = true
        issueTypeSelectorTouchInterceptor.topAnchor.constraint(equalTo: issueTypeSelector.topAnchor).isActive = true
        issueTypeSelectorTouchInterceptor.bottomAnchor.constraint(equalTo: issueTypeSelector.bottomAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onSelectIssueType))
        issueTypeSelectorTouchInterceptor.addGestureRecognizer(tap)
        issueTypeSelectorTouchInterceptor.isUserInteractionEnabled = false
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
        
        
        descriptionField.textContainerInset = UIEdgeInsets(top: 10.0, left: summaryField.textInsets.left - 4.0, bottom: 10.0, right: summaryField.textInsets.right - 4.0 )
        descriptionField.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        descriptionField.font = label.font
        descriptionField.textColor = UIColor.black
        descriptionField.textAlignment = .left
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        descriptionField.text = ""
        descriptionField.keyboardType = .asciiCapable
        descriptionField.autocapitalizationType = .none
        descriptionField.isEditable = false
        descriptionField.isUserInteractionEnabled = false
        descriptionField.delegate = self
        
        
        contentView.addSubview(descriptionField)
        descriptionField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        descriptionField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        descriptionField.heightAnchor.constraint(equalToConstant: 140.0).isActive = true
        descriptionField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3.0).isActive = true
        
        let toolbar = TextViewAccessoryView()
        toolbar.addTarget(self, action: #selector(onDismissDescription))
        descriptionField.inputAccessoryView = toolbar
    }
    
    private func setupMediaAttachmentToggles() {
        if snapshot != nil {
            checkboxMedia = CheckboxControl(label: "Screenshot attached")
        } else if videoURL != nil {
            checkboxMedia = CheckboxControl(label: "Screen recording attached")
        }
        
        var topLogReference : UIView = descriptionField
        if checkboxMedia != nil {
            topLogReference = checkboxMedia!
            checkboxMedia.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(checkboxMedia)
            checkboxMedia.leadingAnchor.constraint(equalTo: descriptionField.leadingAnchor).isActive = true
            checkboxMedia.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 20.0).isActive = true
            checkboxMedia.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            checkboxMedia.trailingAnchor.constraint(equalTo: descriptionField.trailingAnchor).isActive = true
            checkboxMedia.isSelected = true
        }
        
        checkboxLog.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkboxLog)
        checkboxLog.topAnchor.constraint(equalTo: topLogReference.bottomAnchor, constant: topLogReference == descriptionField ? 20.0 : 10.0 ).isActive = true
        checkboxLog.leadingAnchor.constraint(equalTo: descriptionField.leadingAnchor).isActive = true
        checkboxLog.trailingAnchor.constraint(equalTo: descriptionField.trailingAnchor).isActive = true
        checkboxLog.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        checkboxLog.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0).isActive = true
        checkboxLog.isSelected = true
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
        
        UserDefaults.standard.jiraProject = project?.identifier  // Save the selected project for future iterations
        let controller = UIAlertController(title: "Wait a sec...", message: "Loading JIRA's project configuration", preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
        
        JIRARestAPI.sharedInstance.fetchCreateIssueMetadata(project: jiraProject) { [weak self] (issueTypes) in
            controller.dismiss(animated: true, completion: {
                self?.issueTypesForProject = issueTypes
                self?.issueTypeSelectorTouchInterceptor.isUserInteractionEnabled = true
                self?.buildIssueTypeSelector(issueTypes: issueTypes)
            })
        }
    }
    
    // MARK: - Build selection of issue type
    
    private func buildIssueTypeSelector( issueTypes : [JIRA.Project.IssueType]? ) {
        guard let types = issueTypes else { return }
        
        view.endEditing(false)
        
        let optionsController = OptionSelectorPopupViewController<JIRA.Project.IssueType>()
        optionsController.options = types
        optionsController.propertyName = "name"
        optionsController.selectionHandler = {
            [weak self, weak optionsController] (option) in

            self?.issueTypeSelected(issueType: option)
            self?.autocomplete.isLocked = true
            self?.summaryField.becomeFirstResponder()
            optionsController?.dismiss(animated: true, completion: nil)
        }
        
        optionsController.modalPresentationStyle = .popover
        optionsController.popoverPresentationController?.delegate = self
        optionsController.popoverPresentationController?.backgroundColor = UIColor.clear
        optionsController.popoverPresentationController?.sourceView = issueTypeSelector
        optionsController.popoverPresentationController?.sourceRect = CGRect(x: issueTypeSelector.bounds.midX - 10.0, y: issueTypeSelector.bounds.height - 20.0 , width: 20.0, height: 10.0)
        optionsController.popoverPresentationController?.permittedArrowDirections = [.up,.down]
        optionsController.preferredContentSize = CGSize(width: issueTypeSelector.bounds.width, height: 150.0)
        present(optionsController, animated: true, completion: nil)
    }
    
    private func issueTypeSelected( issueType : JIRA.Project.IssueType ) {
        issueTypeSelector.text = issueType.name ?? ""
        issueTypeSelected = issueType
        summaryField.isEnabled = true
        descriptionField.isEditable = true
        descriptionField.isUserInteractionEnabled = true
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
            } else if ($0.key ?? "") == "environment" {
                let value = JIRA.IssueField.Value()
                value.stringValue = UIDevice.current.deviceLoggingData.textPresentation
                $0.value = value
            }
        }
        
        loadingViewController?.message = "Creating \(issueTypeSelected?.name ?? "Unknown" ) in JIRA"
        
        // TODO: Check if a we're missing a required object
        JIRARestAPI.sharedInstance.createIssue(fields: fields) {
            [weak self] (issue,errors) in
            self?.handleCreateIssueResponse(errors: errors, issue: issue)
        }
    }
    
    // MARK: - UITextViewDeleagate
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        inputField = textView
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        inputField = nil
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        scrollToVisibleInput()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView === inputField {
            inputField = nil
        }
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        inputField = textField
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let result = textField.text?.trimmingCharacters(in: CharacterSet.whitespaces).count ?? 0 > 0
        
        if result {
            inputField = descriptionField
            descriptionField.becomeFirstResponder()
        }
        
        return result
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if inputField === textField {
            inputField = nil
        }
    }
    
    // MARK: - Support
    
    /**
        Uploads the annotated snapshot as an attachment.
        - Parameter issue: The issue created previously with the summary and description provided by the UI.
    */
    private func uploadImage( issue : JIRA.Object ) {
        loadingViewController?.message = "Uploading snapshot..."
        JIRARestAPI.sharedInstance.attach(snapshot: snapshot!, issue: issue) { [weak self] (_, errors) in
            
            guard let strongSelf = self else { return }
            strongSelf.handleAttachmentResponse(issue: issue, errors: errors, caller: strongSelf.uploadImage(issue:))
        }
    }
    
    /**
        Uploads the video result of the annotated screen recording.
        - Parameter issue: The issue created previously with the summary and description provided by the UI.
     */
    private func uploadScreenRecording( issue : JIRA.Object ) {
        loadingViewController?.message = "Uploading video..."
        JIRARestAPI.sharedInstance.attach(fileURL: videoURL!, mimeType: .mp4Video, issue: issue) { [weak self] (_, errors) in
            
            guard let strongSelf = self else { return }
            strongSelf.handleAttachmentResponse(issue: issue, errors: errors, caller: strongSelf.uploadScreenRecording(issue:))
        }
    }
    
    private func uploadLogs( issue : JIRA.Object ) {
        guard let data = UIApplication.lastLogs(),
              checkboxLog.isSelected else {
            
            dismissLoading {
                [weak self] in
                self?.showSuccess(issue: issue)
            }
            
            return
        }
        loadingViewController?.message = "Uploading log files..."
        JIRARestAPI.sharedInstance.attach(data: data,
                                          fileName: FileManager.buildAppFileName(),
                                          mimeType: .plainText,
                                          issue: issue) { [weak self] (_, errors) in
            self?.handleLogsAttachmentResponse(issue: issue, errors: errors)
        }
    }
    
    // MARK: - Handle network calls
    
    private func handleCreateIssueResponse(errors : [String]?, issue : JIRA.Object? ) {
        
        if let errorMessages = errors {
            dismissLoading {
                [weak self] in
                self?.presentOperationErrors(errors: errorMessages)
            }
            return
        }
        
        // Check the issue object was created correctly
        guard let issueObject = issue else {
            
            // Just dismiss the loading view controller and present the error
            handleCreateIssueResponse(errors: ["The issue object wasn't found in the response"], issue: nil)
            return
        }
        
        guard checkboxMedia != nil && checkboxMedia.isSelected else {
            uploadLogs(issue: issueObject)
            return
        }
        
        // Check if the form has an image
        if snapshot != nil  {
            uploadImage(issue: issueObject)
        // Check if the form has the URL of a video
        } else if videoURL != nil {
            uploadScreenRecording(issue: issueObject)
        }
    }
    
    private func handleAttachmentResponse( issue : JIRA.Object , errors : [String]? , caller : @escaping (JIRA.Object)->Void ) {
        if errors == nil {
            uploadLogs(issue: issue)
        } else {
            let controller = loadingViewController == nil ? self : loadingViewController
            controller?.presentOperationErrors(errors: errors!, retry : {
                caller(issue)
            }) { [weak self] in
                self?.uploadLogs(issue: issue)
            }
        }
    }
    
    private func handleLogsAttachmentResponse( issue : JIRA.Object , errors: [String]? ) {
        if errors == nil {
            dismissLoading {
                [weak self] in
                self?.showSuccess(issue: issue)
            }
            
        } else {
            
            // Present the errors and optionally retry uploading the attachment
            let controller = loadingViewController == nil ? self : loadingViewController
            controller?.presentOperationErrors(errors: errors!, retry : {
                [weak self] in
                self?.uploadLogs(issue: issue)
            }) { [weak self] in
                self?.handleLogsAttachmentResponse(issue: issue, errors: nil)
            }
        }
    }
    
    // MARK: - Presentation support
    
    private func dismissLoading( completion : @escaping ()->Void ) {
        guard let loading = loadingViewController else {
            completion()
            return
        }
        loading.dismiss(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                completion()
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
