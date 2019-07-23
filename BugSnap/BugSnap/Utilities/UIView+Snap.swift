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
    
    /**
        Creates a recording indicator that ReplayKit won't record when recording the screen.
    */
    @objc static func addRecordingIndicator() -> UIWindow {
        let recordingIndicatorWindow = UIWindow(frame: UIScreen.main.bounds)
        recordingIndicatorWindow.isHidden = false
        recordingIndicatorWindow.backgroundColor = UIColor.clear
        recordingIndicatorWindow.isUserInteractionEnabled = false
        
        let indicatorViewContainer = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        indicatorViewContainer.cornerRadius = 8.0
        indicatorViewContainer.translatesAutoresizingMaskIntoConstraints = false
        recordingIndicatorWindow.addSubview(indicatorViewContainer)
        
        indicatorViewContainer.topAnchor.constraint(equalTo: recordingIndicatorWindow.safeAreaLayoutGuide.topAnchor).isActive = true
        indicatorViewContainer.trailingAnchor.constraint(equalTo: recordingIndicatorWindow.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.text = "Recording..."
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        indicatorViewContainer.contentView.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: indicatorViewContainer.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: indicatorViewContainer.leadingAnchor, constant: 10.0).isActive = true
        
        
        let recording = UIView()
        recording.backgroundColor = UIColor.red
        recording.cornerRadius = 10.0
        recording.translatesAutoresizingMaskIntoConstraints = false
        indicatorViewContainer.contentView.addSubview(recording)
        
        recording.centerYAnchor.constraint(equalTo: indicatorViewContainer.centerYAnchor).isActive = true
        recording.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        recording.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        recording.trailingAnchor.constraint(equalTo: indicatorViewContainer.trailingAnchor, constant: -10.0).isActive = true
        recording.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10.0).isActive = true
        recording.topAnchor.constraint(equalTo: indicatorViewContainer.topAnchor, constant: 10.0).isActive = true
        recording.bottomAnchor.constraint(equalTo: indicatorViewContainer.bottomAnchor, constant: -10.0).isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.beginFromCurrentState,.autoreverse,.repeat], animations: {
            recording.alpha = 0.4
        }, completion: nil)
        
        return recordingIndicatorWindow
    }
}
