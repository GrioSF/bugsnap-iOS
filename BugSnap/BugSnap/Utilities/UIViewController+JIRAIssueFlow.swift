//
//  UIViewController+JIRAIssueFlow.swift
//  BugSnap
//
//  Created by Héctor García Peña on 7/23/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation
import UIKit

/**
    Allows to present the UI for connecting with JIRA and capture the information for an issue.
*/
public extension UIViewController {
    
    
    /**
        Starts the flow for capturing the issue with a snapshot or a video URL (that can be captured with the framework too).
        This method presents the JIRALoginViewController to validate the credentials and then JIRAIssueFormViewController to finalize the capture of the information related to the issue. After the information is validated it can be uploaded to JIRA.
        - Parameter snapshot: The snapshot to be uploaded to JIRA as attachement
        - Parameter videoURL: The videoURL (in the local file system, ideally in the caches directory) to be uploaded in JIRA as an attachement.
    */
    @objc func startJIRACapture( snapshot : UIImage? = nil, videoURL : URL? = nil) {
        let jiraLoginViewController = JIRALoginViewController()
        jiraLoginViewController.modalPresentationStyle = .overCurrentContext
        jiraLoginViewController.modalTransitionStyle = .coverVertical
        present(jiraLoginViewController, animated: true, completion: nil)
        
        jiraLoginViewController.onSuccess = {
            [weak self] in
            
            let controller = JIRAIssueFormViewController()
            controller.snapshot = snapshot
            controller.videoURL = videoURL
            controller.modalTransitionStyle = .crossDissolve
            self?.present(controller, animated: true, completion: nil)
        }
    }
}
