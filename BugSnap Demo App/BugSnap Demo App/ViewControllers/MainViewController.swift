//
//  MainViewController.swift
//  BugSnap Demo App
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import UIKit
import BugSnap

/**
    Test view controller with a unwind segue
*/
class MainViewController: UIViewController {

    // MARK: - Navigation
    
    var window : UIWindow? = nil

    /**
        Manage unwind to this view controller
    */
    @IBAction func unwindToMainViewController( segue : UIStoryboardSegue ) {
        
    }
    
    /**
        Presents a test alert.
    */
    @IBAction func presentAlert() {
        
        /*
        let alert = UIAlertController(title: "Alert", message: "test alert", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        window = UIView.addRecordingIndicator()
        */
        let controller = FeedbackCardViewController()
        controller.snapshot = UIImage(named: "TestImage")
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true, completion: nil)
    }
    
    
    /**
        Take a snapshot
    */
    @IBAction func takeSnapshot() {
        NotificationCenter.default.post(name: .shakeEventDetected, object: nil)
    }

}
