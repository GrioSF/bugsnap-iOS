//
//  UIApplication+Snap.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit
import ReplayKit

/// A key for storing the reference to the shake detector
fileprivate var _shakeDetectorReferenceKey = "_shakeDetectorReferenceKey"






/**
    Extension of UIApplication in order to activate the accelerometer and manage the App states to continue capturing the
    input from the user. This would be useful if needed to use the shake event to trigger the view controller capture.
*/
public extension UIApplication {
    
    /// The name for the app (specified in the display name)
    @objc var appName : String {
        let appName = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? "BugSnap"
        return appName
    }
    
    /**
        Starts the accelerometer in the device in order to trigger a capture for the top most view controller.
        If the accelerometer is already initiated this method won't do anything. The accelerometer call should be done in the main thread and in foreground (this is validated), otherwise it won't do anything.
        - Parameter timeToSettle: This is the time to wait the device to settle after the shake movement was detected.
    */
    @objc func enableShakeGestureSnap( timeToSettle : TimeInterval = 1.1) {
        
        // Check if we're in the main thread and if we're in the foreground
        guard Thread.current.isMainThread,
            applicationState != .background else {
                NSLog("Tried to enable shake gesture on either a secondary thread or in a non active state")
                return
        }
        
        // Check the shake detector
        var shakeDetector : AccelerometerShakeDetector! = objc_getAssociatedObject(self, &_shakeDetectorReferenceKey) as? AccelerometerShakeDetector
        
        // Haven't been instantiated
        if shakeDetector == nil {
            shakeDetector = AccelerometerShakeDetector()
            objc_setAssociatedObject(self, &_shakeDetectorReferenceKey, shakeDetector, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        // Register for notifications for the shake event
        NotificationCenter.default.addObserver(self, selector: #selector(onSnapRequested(notification:)), name: .shakeEventDetected, object: nil)
        shakeDetector.timeToSettleAfterShake = timeToSettle
        _ = shakeDetector.startAccelerometerUpdates()
    }
    
    /**
        Disables the generation of accelerometer shake gestures to trigger the snap
        This method validates its execution on the main thread and when the app is not in background, otherwise it doesn't do anything
    */
    func disableShakeGestureSnap() {
        guard Thread.current.isMainThread,
            applicationState != .background else {
                NSLog("Tried to disable shake gesture on either a secondary thread or in a non active state")
                return
        }
        
        if let shakeDetector = objc_getAssociatedObject(self, &_shakeDetectorReferenceKey) as? AccelerometerShakeDetector {
            shakeDetector.stopAccelerometerUpdates()
            NotificationCenter.default.removeObserver(self, name: .shakeEventDetected, object: nil)
        }
    }
    
    
    // MARK: - Support for the actual event triggered
    
    /**
        The actual management of the snap event. This event can be triggered from the accelerometer or any other method.
        This method is supposed to be executed on the main thread and when the app is not in the background (this is enforced)
     
        - Parameter notification: The notification object
    */
    @objc fileprivate func onSnapRequested( notification : Notification ) {
        
        guard Thread.current.isMainThread,
            applicationState != .background else {
                NSLog("Tried to enable shake gesture on either a secondary thread or in a non active state")
                return
        }
        
        // check whether we're already recording
        if isScreenRecording {
            doEndCapture()
        // Check whether the screen recorder is available
        } else if RPScreenRecorder.shared().isAvailable {
            askSnapAction()
        // Otherwise defaults to the snapshot action
        } else {
            takeSnapshot()
        }
    }
    
    // MARK: - Support
    
    private func askSnapAction() {
        guard let topMost = UIViewController.topMostViewController else {
                NSLog("Couldn't find either the key window or the top most view controller")
                return
        }
        
        let optionSheetController = CaptureOptionSheetViewController()
        optionSheetController.optionSelectionHandler = {
            [weak self] (option) in
            switch option {
            case .screenrecording:
                self?.promptRecording()
            case .screenshot:
                self?.takeSnapshot()
            default:
                break
            }
        }
        optionSheetController.modalPresentationStyle = .overCurrentContext
        topMost.present(optionSheetController, animated: true, completion: nil)
    }

    
    /**
        Tries to take the snapshot from the main window (keyWindow) and then loads the MarkupEditorController
        This method uses the snapshot method from the UIView category in order to have the capture of the screen and then
        it loads the MarkupEditorViewController to allow the user for edits presenting it as the topMost View Controller
    */
    private func takeSnapshot() {
        guard
            let view = keyWindow,
            let topMost = UIViewController.topMostViewController else {
                NSLog("Couldn't find either the key window or the top most view controller")
                return
        }
        
        // Take the snapshot and present the view controller
        view.snapshot( flashing : true) { (image) in
            
            let loading = topMost.presentLoading(message: "Loading image...")
            
            let snapController = MarkupEditorViewController()
            snapController.screenSnapshot = image
            let navigationController = IrisTransitioningNavigationController(rootViewController: snapController)
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                navigationController.modalPresentationStyle = .formSheet
            }
            
            snapController.view.backgroundColor = UIColor.black
            
            loading.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    topMost.present(navigationController, animated: true, completion: nil)
                })
            })
        }
    }
}
