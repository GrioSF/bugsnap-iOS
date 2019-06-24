//
//  LaunchViewController.swift
//  BugSnap Demo App
//
//  Created by Héctor García Peña on 6/18/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import UIKit
import BugSnap

/**
    View controller to easy the transition between the launch screen and the next screen
*/
class LaunchViewController: UIViewController {
    
    // MARK: - IB Properties
    
    /// The logo image
    @IBOutlet weak var logo : UIImageView!

    // MARK: - View Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.performSegue(withIdentifier: "main", sender: nil)
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.beginFromCurrentState,.curveEaseIn], animations: {
            self.logo.transform = CGAffineTransform(rotationAngle: CGFloat(180.0).radians).concatenating(CGAffineTransform(scaleX: 5.0, y: 5.0))
        }, completion: nil)
    }


}
