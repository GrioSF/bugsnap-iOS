//
//  MainViewController.swift
//  BugSnap Demo App
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Test view controller with a unwind segue
*/
class MainViewController: UIViewController {

    // MARK: - Navigation

    /**
        Manage unwind to this view controller
    */
    @IBAction func unwindToMainViewController( segue : UIStoryboardSegue ) {
        
    }
    
    /**
        Presents a test alert.
    */
    @IBAction func presentAlert() {
        let alert = UIAlertController(title: "Alert", message: "test alert", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
