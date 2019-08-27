//
//  JIRAIssueCreator.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/22/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Utility object to create a JIRA Issue with a snapshot attachment.
    All the parameters are read from the preferences set up for the library
*/
public class JIRAIssueCreator: NSObject {

    /// The view controller to block for setting up the issue
    @objc public weak var viewController : UIViewController!
    
    // MARK: - Data Fields
    
    /// The issue type (bug)
    private var issueTypeSelected : JIRA.Project.IssueType? = nil
    
    /// The issue types associated to this project
    private var issueTypesForProject : [JIRA.Project.IssueType]? = nil
    
    /// A loading view controller
    private weak var loadingViewController : LoadingViewController? = nil
    
    /// The text to set in the issue
    private var issueText : String!
    
    /// The snapshot to set in the issue
    private var snapshot : UIImage!
    
    /// MARK: - Facing API
    
    
    @objc public func createIssue( text : String, snapshot : UIImage ) {
        issueText = text
        self.snapshot = snapshot
        selectProject()
    }
    
    // MARK: - Attachments support
    
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
    
    private func uploadLogs( issue : JIRA.Object ) {
        guard let data = UIApplication.lastLogs() else {
            
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
    
    // MARK: - JIRA Issue uploading support
    
    private func selectProject() {
        let project = UserDefaults.standard.jiraProject!.localizedLowercase
        
        loadingViewController = viewController.presentLoading(message: "Finding JIRA Project...")
        JIRARestAPI.sharedInstance.allProjects {
            [weak self] (projects) in
            guard projects != nil && projects!.count > 0 else {
                return
            }
            let filteredObjects = projects?.filter {
                $0.key?.localizedLowercase == project || $0.name?.localizedLowercase == project  || $0.identifier == project
            }
            if (filteredObjects?.count ?? 0) == 1 {
                self?.fetchProjectMetadata(jiraProject: filteredObjects!.first!)
                return
            }
        }
    }
    
    private func fetchProjectMetadata( jiraProject : JIRA.Object ) {
        
        loadingViewController?.message = "Fetching project metadata"
        JIRARestAPI.sharedInstance.fetchCreateIssueMetadata(project: jiraProject as! JIRA.Project) { [weak self] (issueTypes) in
            /// The identifier 1 is for bug
            let filteredIssues = issueTypes?.filter { $0.identifier == "1" }
            if let issueType = filteredIssues?.first {
                self?.createIssue(jiraIssue: issueType)
            }
        }
    }
    
    private func createIssue( jiraIssue : JIRA.Project.IssueType ) {
        guard let fields = jiraIssue.fields else {
            
            return
        }
        
        fields.forEach {
            if ($0.key ?? "") == "summary" {
                let value = JIRA.IssueField.Value()
                value.stringValue = issueText
                $0.value = value
            } else if ($0.key ?? "") == "description" {
                let value = JIRA.IssueField.Value()
                value.stringValue = issueText
                $0.value = value
            } else if ($0.key ?? "") == "environment" {
                let value = JIRA.IssueField.Value()
                value.stringValue = UIDevice.current.deviceLoggingData.textPresentation
                $0.value = value
            }
        }
        
        loadingViewController?.message = "Creating \(jiraIssue.name ?? "Unknown" ) in JIRA"
        
        // TODO: Check if a we're missing a required object
        JIRARestAPI.sharedInstance.createIssue(fields: fields) {
            [weak self] (issue,errors) in
            self?.handleCreateIssueResponse(errors: errors, issue: issue)
        }
    }
    
    private func handleCreateIssueResponse(errors : [String]?, issue : JIRA.Object? ) {
        
        if let errorMessages = errors {
            dismissLoading {
                [weak self] in
                self?.viewController.presentOperationErrors(errors: errorMessages)
            }
            return
        }
        
        // Check the issue object was created correctly
        guard let issueObject = issue else {
            
            // Just dismiss the loading view controller and present the error
            handleCreateIssueResponse(errors: ["The issue object wasn't found in the response"], issue: nil)
            return
        }
        
        uploadImage(issue: issueObject)
    }
    
    private func handleAttachmentResponse( issue : JIRA.Object , errors : [String]? , caller : @escaping (JIRA.Object)->Void ) {
        if errors == nil {
            uploadLogs(issue: issue)
        } else {
            let controller = loadingViewController == nil ? viewController : loadingViewController
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
            let controller = loadingViewController == nil ? viewController : loadingViewController
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
                self?.viewController.dismiss(animated: true, completion: nil)
            })
        }))
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
}
