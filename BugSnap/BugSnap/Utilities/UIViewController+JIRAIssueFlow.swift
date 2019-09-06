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
     
        - Parameter snapshot: The snapshot to be uploaded to JIRA as attachement
        - Parameter videoURL: The videoURL (in the local file system, ideally in the caches directory) to be uploaded in JIRA as an attachement.
    */
    @objc func startJIRACapture( snapshot : UIImage? = nil, videoURL : URL? = nil) {
        if UIApplication.shared.userFeedbackFlow {
            startUserFeedbackFlow(snapshot: snapshot, videoURL: videoURL)
        } else {
            startJIRAUserFeedbackFlow(snapshot: snapshot, videoURL: videoURL)
        }
    }
    
    /**
        Starts the flow for user feedback with a card being presented.
        - Parameter snapshot: The snapshot to be uploaded to JIRA as attachement
        - Parameter videoURL: The videoURL (in the local file system, ideally in the caches directory) to be uploaded in JIRA as an attachement.
    */
    private func startUserFeedbackFlow( snapshot : UIImage? = nil, videoURL : URL? = nil ) {
        
        guard let topMost = UIViewController.topMostViewController else {
            return
        }
        let loading = topMost.presentLoading(message: "Loading image...")
        
        let controller = FeedbackCaptureViewController()
        controller.snapshot = snapshot
        controller.videoURL = videoURL
        controller.modalPresentationStyle = .overCurrentContext
        
        loading.dismiss(animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                topMost.present(controller, animated: true, completion: nil)
            })
        })
    }
    
    /**
        This method presents the JIRALoginViewController to validate the credentials and then JIRAIssueFormViewController to finalize the capture of the information related to the issue. After the information is validated it can be uploaded to JIRA.
        - Parameter snapshot: The image captured from the screen
        - Parameter videoURL: The video URL for the video screen recording.
    */
    private func startJIRAUserFeedbackFlow( snapshot : UIImage? = nil, videoURL : URL? = nil) {
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
