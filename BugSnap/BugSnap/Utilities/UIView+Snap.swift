//
//  UIWindow+Snap.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import Foundation
import AudioToolbox

/**
    Extension to capture the screen in a single image. This uses the UIView method to render the window in a single image.
*/
public extension UIView {
    
    /**
        Takes a snapshot from this window.
        - Parameter completion: The closure to be called with the image captured.
    */
    func snapshot( flashing : Bool = false, completion : @escaping (UIImage?)->Void )  {
        
        
        // Try to capture the view
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard flashing else {
            completion(image)
            return
        }
        
        // Animation to simulate the capture of the screen
        let fxView = UIView()
        fxView.bounds = bounds
        fxView.center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        fxView.backgroundColor = UIColor.white
        fxView.alpha = 0.0
        addSubview(fxView)
        UIView.animate(withDuration: 0.7, delay: 0.0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            fxView.alpha = 1.0
        }) { (_) in
            AudioServicesPlaySystemSound(1108)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.beginFromCurrentState,.curveEaseIn], animations: {
                fxView.alpha = 0.0
            }) { (_) in
                fxView.removeFromSuperview()
                completion(image)
            }
        }
    }
}
