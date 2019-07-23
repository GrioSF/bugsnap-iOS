//
//  UIApplication+ScreenRecording.swift
//  BugSnap
//
//  Created by Héctor García Peña on 7/22/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation
import ReplayKit
import UIKit
import AVFoundation





/// A key for storing whether the application is recording the screen
fileprivate var _shakeStopRecordingKey = "_shakeStopRecordingKey"

/// A key for the secondary screen recording window
fileprivate var _recordingIndicatorWindow = "_recordingIndicatorWindow"

/// A key for storing the file for saving the video
fileprivate var _avassetwriterfile = "_avassetwriterfile"

/// Extension to support screen recording
extension UIApplication {
    
    /// Flag to know whether the shake is for start/stopping the screen recording
    var isScreenRecording : Bool {
        get {
            guard let number = objc_getAssociatedObject(self, &_shakeStopRecordingKey) as? NSNumber else { return false }
            return number.boolValue
        }
        set(newVal) {
            let number = NSNumber(booleanLiteral: newVal)
            willChangeValue(forKey: "isScreenRecording")
            objc_setAssociatedObject(self, &_shakeStopRecordingKey, number, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "isScreenRecording")
        }
    }
    
    /// The video writer
    var videoWriter : VideoFileWriter? {
        get {
            return objc_getAssociatedObject(self, &_avassetwriterfile) as? VideoFileWriter
        }
        set(newVal) {
            objc_setAssociatedObject(self, &_avassetwriterfile, newVal, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// A secondary UIWindow to show the screen recording indicator
    private var screenRecordingIndicator : UIWindow? {
        get {
            return objc_getAssociatedObject(self, &_recordingIndicatorWindow) as? UIWindow
        }
        set(newVal) {
            willChangeValue(forKey: "screenRecordingIndicator")
            objc_setAssociatedObject(self, &_recordingIndicatorWindow, newVal, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "screenRecordingIndicator")
        }
    }
    
    /**
        Presents an alert to notify the device is going to start recording its screen and also the microphone.
     */
    func promptRecording() {
        guard let topMost = UIViewController.topMostViewController else {
            NSLog("Couldn't find either the key window or the top most view controller")
            return
        }
        
        let alertController = UIAlertController(title: "Recording", message: "Device will start recording the screen and microphone, please shake again to stop recording", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                self.doStartCapture()
            })
        }))
        topMost.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Replay Kit 2 Capture
    
    private func doStartCapture() {
        
        let videoWriter =  VideoFileWriter()
        self.videoWriter = videoWriter
        
        RPScreenRecorder.shared().delegate = self
        RPScreenRecorder.shared().isMicrophoneEnabled = true
        RPScreenRecorder.shared().startCapture(handler: { [weak self] (buffer, bufferType, error) in
            guard error == nil else { return }
        
            self?.isScreenRecording = true
            if self?.screenRecordingIndicator == nil {
                DispatchQueue.main.async {
                    let window  = UIView.addRecordingIndicator()
                    self?.screenRecordingIndicator = window
                }
            }
            
            videoWriter.append(sample: buffer, sampleType: bufferType)
        }) { [weak self] (error) in
            if let recError = error {
                self?.videoWriter = nil
                DispatchQueue.main.async {
                    UIViewController.topMostViewController?.presentOperationErrors(errors: ["\(recError)"], title: "Oops!", button: "Ok")
                }
                return
            }
        }
    }
    
    func doEndCapture() {
        DispatchQueue.main.async {
            let loading = UIViewController.topMostViewController?.presentLoading(message: "Stopping capture...")
            RPScreenRecorder.shared().stopCapture { [weak self] (error) in
                DispatchQueue.main.async {
                    self?.showEndCapture(loading: loading!, error: error)
                    RPScreenRecorder.shared().delegate = nil
                }
            }
            
        }
    }
    
    // MARK: - Support UI
    
    private func showEndCapture( loading : LoadingViewController,  error : Error? = nil ) {
        isScreenRecording = false
        screenRecordingIndicator = nil
        
        let videoURL = videoWriter?.videoOutputURL
        
        // Present the error
        if let recError = error {
            loading.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    UIViewController.topMostViewController?.presentOperationErrors(errors: ["\(recError)"], title: "Oops!", button: "Ok")
                })
            })
            return
        }
        
        // Update the message
        loading.message = "Wrapping up video..."
        videoWriter?.endWriter {
            loading.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    UIViewController.topMostViewController?.startJIRACapture( videoURL: videoURL)
                })
            })
        }
    }
    

    // MARK: - Replay Kit Version 1.0 Interface
    
    private func doStartRecording() {
        RPScreenRecorder.shared().isMicrophoneEnabled = true
        RPScreenRecorder.shared().startRecording { [weak self] (error) in
            DispatchQueue.main.async {
                if let recError = error {
                    UIViewController.topMostViewController?.presentOperationErrors(errors: ["\(recError)"], title: "Oops!", button: "Ok")
                    return
                }
                let window  = UIView.addRecordingIndicator()
                self?.screenRecordingIndicator = window
                self?.isScreenRecording = true
            }
        }
    }
    
    func doStopRecording() {
        RPScreenRecorder.shared().stopRecording { [weak self] (preview, error) in
            self?.screenRecordingIndicator = nil
            if let recError = error {
                UIViewController.topMostViewController?.presentOperationErrors(errors: ["\(recError)"], title: "Oops!", button: "Ok")
                return
            }
            self?.presentScreenRecorderPreviewController(preview: preview)
        }
    }
    
    private func presentScreenRecorderPreviewController( preview : RPPreviewViewController? ) {
        guard let topMost = UIViewController.topMostViewController,
            let previewViewController = preview else {
                return
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            previewViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            previewViewController.popoverPresentationController?.sourceRect = CGRect.zero
            previewViewController.popoverPresentationController?.sourceView = topMost.view
        }
        
        topMost.present(previewViewController, animated: true, completion: nil)
    }
}

/**
    Extension to support the : RPScreenRecorderDelegate protocolo and allow to react to situations in which the screen recording is stopped
*/
extension UIApplication : RPScreenRecorderDelegate {
    
    public func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        print("screen recorder did stop recording")
    }
    
    public func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        print("screen Recorder did change availability")
    }
}
